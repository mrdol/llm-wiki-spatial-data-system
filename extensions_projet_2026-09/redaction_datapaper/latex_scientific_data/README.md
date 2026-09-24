# Scientific Data LaTeX working manuscript

This directory contains a standalone LaTeX skeleton for a *Scientific Data*
Data Descriptor. The journal does not mandate a visual template for initial
review; its required section order is implemented in
`manuscript_scientific_data.tex`.

Compile from PowerShell:

```powershell
.\build_manuscript.ps1
```

The `build/` directory contains the PDF and the auxiliary files produced by
Tectonic (`.aux`, `.log`, `.synctex.gz`, and `.out` when non-empty). Keep these
files for the requested working bundle, but submit only the files required by
the journal.

The `.tex` is standalone and contains an embedded `thebibliography` block. This
meets the journal's revised-manuscript requirement that the uploaded `.tex`
compile without an external `.bib` or style file. During drafting, verified
references can be maintained in the project's master `.bib`; before submission,
the final bibliography must be embedded in this file.

Amber boxes are deliberate scientific placeholders. They mark information that
must come from the frozen bank snapshot, repository deposit, licence audit or
confirmed author metadata. They should all be removed before submission.

Official guidance checked on 21 September 2026:

- <https://www.nature.com/sdata/publish/submission-guidelines>
- <https://www.nature.com/sdata/policies/data-policies>
- <https://www.nature.com/sdata/policies/repositories>
