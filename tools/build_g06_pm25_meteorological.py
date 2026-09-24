"""Reconstruct G06 winter-2011 PM2.5 and meteorological covariates.

Sources follow the article: EPA AQS daily PM2.5, Livneh precipitation,
temperature and wind, and NARR relative humidity and cloud cover.  NOAA NCSS
queries retain only January, February and December 2011 over the conterminous
US.  Monthly gridded means are weighted by days in month and matched to the
nearest grid cell.  The paper does not publish its final station list or join
code, so the output remains a documented reconstruction pending comparison
with the authors' analytical data.
"""

from __future__ import annotations

import argparse
import calendar
import io
import urllib.parse
import urllib.request
import urllib.error
import zipfile
from pathlib import Path

import netCDF4
import numpy as np
import pandas as pd
from pyproj import CRS, Transformer

MONTHS = (1, 2, 12)
BOUNDS = {"north": 50, "south": 24, "west": -125, "east": -66}
LIVNEH = {
    "PPTN": ("prec.mon.mean.nc", "prec"),
    "Tmin": ("tmin.mon.mean.nc", "tmin"),
    "Tmax": ("tmax.mon.mean.nc", "tmax"),
    "WS": ("wind.mon.mean.nc", "wind"),
}
NARR = {
    "RH": ("rhum.2m.mon.mean.nc", "rhum"),
    "TCDC": ("tcdc.mon.mean.nc", "tcdc"),
}


def fetch_subset(url: str, variable: str, month: int, target: Path) -> Path:
    when = f"2011-{month:02d}-01T00:00:00Z"
    params = {"var": variable, **BOUNDS, "time": when, "accept": "netcdf4"}
    request_url = f"{url}?{urllib.parse.urlencode(params)}"
    target.parent.mkdir(parents=True, exist_ok=True)
    if not target.exists():
        print(f"Downloading {variable} for 2011-{month:02d}")
        try:
            with urllib.request.urlopen(request_url, timeout=300) as response:
                target.write_bytes(response.read())
        except urllib.error.HTTPError as exc:
            message = exc.read().decode("utf-8", errors="replace")
            raise RuntimeError(f"NOAA NCSS rejected {request_url}: {message}") from exc
    return target


def nearest_values(path: Path, variable: str, station_lon: np.ndarray, station_lat: np.ndarray) -> np.ndarray:
    with netCDF4.Dataset(path) as ds:
        values = np.asarray(ds.variables[variable][:]).squeeze()
        if "lat" not in ds.variables:
            x = np.asarray(ds.variables["x"][:])
            y = np.asarray(ds.variables["y"][:])
            mapping = ds.variables["Lambert_Conformal"]
            scale = 1000 if getattr(mapping, "units", "") == "km" else 1
            crs = CRS.from_proj4(
                "+proj=lcc +lat_1={0} +lat_0={1} +lon_0={2} +x_0={3} +y_0={4} +R={5} +units=m".format(
                    mapping.standard_parallel,
                    mapping.latitude_of_projection_origin,
                    mapping.longitude_of_central_meridian,
                    mapping.false_easting * scale,
                    mapping.false_northing * scale,
                    mapping.earth_radius,
                )
            )
            sx, sy = Transformer.from_crs("EPSG:4326", crs, always_xy=True).transform(station_lon, station_lat)
            ix = np.abs(x[:, None] - np.asarray(sx)[None, :]).argmin(axis=0)
            iy = np.abs(y[:, None] - np.asarray(sy)[None, :]).argmin(axis=0)
            return values[iy, ix]
        lat = np.asarray(ds.variables["lat"][:])
        lon = np.asarray(ds.variables["lon"][:])
    lon = ((lon + 180) % 360) - 180
    if lat.ndim == 1 and lon.ndim == 1:
        iy = np.abs(lat[:, None] - station_lat[None, :]).argmin(axis=0)
        ix = np.abs(lon[:, None] - station_lon[None, :]).argmin(axis=0)
    else:
        # NARR uses a curvilinear grid.  The equirectangular distance is
        # sufficient for selecting the nearest grid cell at this resolution.
        flat_lat, flat_lon = lat.ravel(), lon.ravel()
        iy = np.empty(len(station_lat), dtype=int)
        for i, (x, y) in enumerate(zip(station_lon, station_lat)):
            d2 = ((flat_lon - x) * np.cos(np.deg2rad(y))) ** 2 + (flat_lat - y) ** 2
            iy[i] = int(np.nanargmin(d2))
        return values.ravel()[iy]
    selected = np.ma.asarray(values[iy, ix]).filled(np.nan).astype(float)
    # Coastal monitors can have their geometrically closest Livneh cell over
    # water.  Select the nearest valid land cell in a small local window.
    for i in np.flatnonzero(~np.isfinite(selected)):
        for radius in range(1, 21):
            y0, y1 = max(0, iy[i] - radius), min(len(lat), iy[i] + radius + 1)
            x0, x1 = max(0, ix[i] - radius), min(len(lon), ix[i] + radius + 1)
            block = np.ma.asarray(values[y0:y1, x0:x1]).filled(np.nan)
            valid = np.argwhere(np.isfinite(block))
            if len(valid):
                yy, xx = valid[:, 0] + y0, valid[:, 1] + x0
                d2 = ((lon[xx] - station_lon[i]) * np.cos(np.deg2rad(station_lat[i]))) ** 2 + (lat[yy] - station_lat[i]) ** 2
                best = int(np.argmin(d2))
                selected[i] = values[yy[best], xx[best]]
                break
    return selected


def read_epa(zip_path: Path) -> pd.DataFrame:
    with zipfile.ZipFile(zip_path) as archive:
        csv_name = next(name for name in archive.namelist() if name.lower().endswith(".csv"))
        with archive.open(csv_name) as stream:
            raw = pd.read_csv(stream, low_memory=False)
    raw["Date Local"] = pd.to_datetime(raw["Date Local"])
    raw = raw[raw["Date Local"].dt.month.isin(MONTHS)].copy()
    raw = raw[raw["Sample Duration"].isin(["24 HOUR", "24-HR BLK AVG"])]
    raw["site_id"] = (
        raw["State Code"].astype(str).str.zfill(2)
        + "-" + raw["County Code"].astype(str).str.zfill(3)
        + "-" + raw["Site Num"].astype(str).str.zfill(4)
    )
    daily = raw.groupby(["site_id", "Date Local"], as_index=False).agg(
        PM25=("Arithmetic Mean", "mean"),
        longitude=("Longitude", "first"),
        latitude=("Latitude", "first"),
    )
    stations = daily.groupby("site_id", as_index=False).agg(
        PM25=("PM25", "mean"),
        n_observed_days=("Date Local", "nunique"),
        longitude=("longitude", "first"),
        latitude=("latitude", "first"),
    )
    # Livneh covers the conterminous US; Figure 7(a) in G06 shows the same
    # continental domain.  Exclude Alaska, Hawaii and territories before the
    # gridded join rather than retaining stations with unavailable covariates.
    return stations[
        stations.longitude.between(BOUNDS["west"], BOUNDS["east"])
        & stations.latitude.between(BOUNDS["south"], BOUNDS["north"])
    ].reset_index(drop=True)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    raw_dir = args.repo / "data/raw/papers/G06_PM25_meteorological"
    epa_zip = raw_dir / "epa_airdata/2011_pm25_88101/daily_88101_2011.zip"
    cache = raw_dir / "noaa_psl_winter_2011_subsets"
    output = args.repo / "data/interim/papers/g06_pm25_meteorological_winter_2011.csv"
    stations = read_epa(epa_zip)

    for label, (filename, variable) in {**LIVNEH, **NARR}.items():
        family = "Projects/livneh/metvars" if label in LIVNEH else "Datasets/NARR/Monthlies/monolevel"
        base = f"https://psl.noaa.gov/thredds/ncss/grid/{family}/{filename}"
        monthly = []
        weights = []
        for month in MONTHS:
            subset = fetch_subset(base, variable, month, cache / f"{variable}_2011_{month:02d}.nc")
            monthly.append(nearest_values(subset, variable, stations.longitude.to_numpy(), stations.latitude.to_numpy()))
            weights.append(calendar.monthrange(2011, month)[1])
        stations[label] = np.ma.average(np.ma.vstack(monthly), axis=0, weights=weights).filled(np.nan)

    stations["sample_status"] = "public_source_reconstruction_pending_author_sample_comparison"
    output.parent.mkdir(parents=True, exist_ok=True)
    stations.to_csv(output, index=False)
    print(f"Wrote {len(stations)} monitoring sites to {output}")


if __name__ == "__main__":
    main()
