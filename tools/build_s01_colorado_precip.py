"""Reconstruct the 1981 Colorado precipitation table used by S01.

The paper reports 217 stations but does not publish their identifiers.  The
historical UCAR object cited by the paper yields 244 stations when its stated
criterion (twelve non-missing monthly precipitation values in 1981) is applied.
This script preserves that reproducible reconstruction and never labels it as
the authors' exact analytical sample.
"""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np
import pandas as pd
import rdata


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    source = args.repo / "data/raw/papers/S01_Colorado_climatological_stations/ucar/US_monthly_met_historical/RData.COmonthly.met"
    output = source.parent / "colorado_precip_1981_reconstruction.csv"

    objects = rdata.conversion.convert(rdata.parser.parse_file(source))
    precip = np.asarray(objects["CO.ppt"], dtype=float)
    locations = np.asarray(objects["CO.loc"], dtype=float)
    station_ids = np.asarray(objects["CO.id"]).astype(str)
    elevation = np.asarray(objects["CO.elev"], dtype=float)

    # UCAR series starts in January 1895; Python indices are zero based.
    first = (1981 - 1895) * 12
    months = precip[first : first + 12, :]
    months[months <= -2_000_000_000] = np.nan
    keep = np.isfinite(months).all(axis=0)
    annual = np.nansum(months[:, keep], axis=0)

    out = pd.DataFrame(
        {
            "station_id": station_ids[keep],
            "longitude": locations[keep, 0],
            "latitude": locations[keep, 1],
            "elevation_m": elevation[keep],
            "annual_precip_1981_mm": annual,
            "log_annual_precip_1981": np.log(annual),
            "observed_months_1981": 12,
            "sample_status": "reconstruction_244_not_exact_paper_217",
        }
    ).sort_values("station_id")
    if len(out) != 244:
        raise RuntimeError(f"Expected 244 reproducible complete stations, found {len(out)}")
    output.parent.mkdir(parents=True, exist_ok=True)
    out.to_csv(output, index=False)
    print(f"Wrote {len(out)} stations to {output}")


if __name__ == "__main__":
    main()
