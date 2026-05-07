# R bridge for Python scrapers

The project keeps the existing Python scrapers as the execution source of truth.

R users can call them through:

```r
source("R/scraping/python_scraper_bridge.R")
```

## Examples

Run a scientific portal scraper:

```r
run_portal_scraper(
  source = "zenodo",
  query = "spatiotemporal spatial panel data",
  max_pages = 1,
  limit = 5,
  view = "summary",
  pretty = TRUE
)
```

Run an institutional warehouse scraper:

```r
run_portal_scraper(
  source = "eurostat",
  query = "employment population region nuts time",
  limit = 5,
  view = "summary",
  pretty = TRUE
)
```

Generate a dry-run plan:

```r
run_portal_plan(
  warehouse_id = "world_bank",
  pretty = TRUE
)
```

Generate a literature plan:

```r
run_literature_plan(
  warehouse_id = "eurostat",
  mailto = "your.email@example.com",
  pretty = TRUE
)
```

The bridge automatically uses `.venv/Scripts/python.exe` on Windows when it exists.
