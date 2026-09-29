# Scientific Data LaTeX working manuscript

The main Data Descriptor is manuscript_scientific_data.tex. Its prior
21 September version is preserved as manuscript_scientific_data.preupdate_2026-09-25.tex.

Compile from this directory in PowerShell:

~~~powershell
.\build_manuscript.ps1
~~~

The builder uses local latexmk/pdfLaTeX when available and keeps Tectonic
as an optional fallback (-UseTectonic). The PDF and log are in build/.
The manuscript embeds its bibliography. The 27 September restructuring does
not yet include figures: the final descriptive figure and table must be
generated from the frozen, redistributable release rather than from the full
internal catalogue.

The data-derived figures can be regenerated from the project root:

~~~powershell
py -3.14 extensions_projet_2026-09/redaction_datapaper/figures/make_F1_empirical_diversity.py
py -3.14 extensions_projet_2026-09/redaction_datapaper/figures/make_F3_composition.py
py -3.14 extensions_projet_2026-09/redaction_datapaper/figures/make_F4_methods_domains.py
~~~

The figure scripts require Matplotlib; F4 also requires NumPy. The
process diagram F2_pipeline_curation.png has its own adjacent script,
make_F2_pipeline.py.

The existing `verify_manuscript_counts.py` checks the earlier dated draft and
must be updated after the publishable snapshot is frozen. It should not be
used to reinsert the 392 internal records as the size of the published bank.

The manuscript now follows the Scientific Data Data Descriptor structure,
using MedMNIST v2 as the primary editorial model and LAGOS-NE, CMPD and the
Construction Motion Data Library as complementary references. Author and
funding details, the frozen release counts, source-data citations,
redistribution rights, public archive, persistent accession and final file
manifest remain to be completed before submission.

The working PDF also reproduces the principal visual cues of the published
MedMNIST v2 article: blue page band, wide left margin, Data Descriptor label,
blue title and section headings, dotted first-page rule and journal-style
footer. This is an internal review facsimile; Nature applies its own house
typesetting after acceptance and does not require authors to submit this
visual template.

The preliminary release snapshot is documented in
`../SNAPSHOT_NOYAU_PUBLIABLE_2026-09-27.md`. It identifies 276 technically
ready candidates from 129 declared sources, but zero strictly publishable
records because licence verification and redistribution approval have not yet
been recorded. These are workflow facts, not numbers to insert as the size of
the published collection.
