"""Static audit of the code and data repositories attached to data papers.

Entry point: ``tools/audit_datapaper_repositories.py``. The package never
executes third-party code: it reads API metadata, file trees and a targeted
selection of small text files, and stores every observation with its source
(repository URL, commit or version, path, lines).
"""
