"""Apply evidence-backed, field-scoped curation after either fiche generator.

The versioned manifest is the source of reviewed decisions. This layer preserves
all unrelated prose and can regenerate those fields on existing fiches without
rerunning discovery, an LLM, or overwriting a user's complete document.
"""
from __future__ import annotations
import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
MANIFEST = ROOT / 'data/manifests/datasets/dataset_curation_overrides.json'


def set_bullet(text: str, key: str, value: str, anchor: str = 'formula_used') -> str:
    pattern = re.compile(r'^- '+re.escape(key)+r':[^\n]*$', re.M)
    replacement = f'- {key}: {value}'
    if pattern.search(text):
        return pattern.sub(lambda _: replacement, text)
    where = re.search(r'^- '+re.escape(anchor)+r':[^\n]*$', text, re.M)
    if where:
        return text[:where.end()]+'\n'+replacement+text[where.end():]
    raise ValueError(f'Missing anchor {anchor!r} for {key!r}')


def apply_curation(text: str, dataset_id: str, manifest: Path = MANIFEST) -> str:
    if not manifest.exists():
        return text
    row = json.loads(manifest.read_text(encoding='utf-8'))['records'].get(dataset_id)
    if not row:
        return text
    original = text
    for key, value in row.get('bullets', {}).items():
        text = set_bullet(text, key, value)
    # Update the selected response's row; leave other candidate Y types intact.
    selected = row.get('selected_response')
    typology = row.get('bullets', {}).get('Selected Y typology')
    if selected and typology:
        lines = text.splitlines()
        type_column = None
        for i, line in enumerate(lines):
            if not line.startswith('|'):
                type_column = None
                continue
            cells = [cell.strip() for cell in line.strip('|').split('|')]
            if cells[0].lower() == 'variable':
                type_column = next((j for j, cell in enumerate(cells)
                                    if cell.lower() in ('typologie', 'typologie y')), None)
            elif cells[0].strip('`') == selected and type_column is not None:
                cells[type_column] = typology
                lines[i] = '| ' + ' | '.join(cells) + ' |'
        text = '\n'.join(lines)+'\n'
    if row.get('bullets', {}).get('formula_used', '').strip('`').lower() == 'pending':
        if re.search(r'^- Formula:', text, re.M):
            text = set_bullet(text, 'Formula', 'PENDING — formule executable indisponible ; conserver la preuve publiee separement dans formula_pub.')
    if 'readiness' in row:
        readiness = row['readiness']
        match = re.search(r'(^benchmark_readiness:\n)(.*?)(?=^```)', text, re.M|re.S)
        if not match:
            raise ValueError(f'{dataset_id}: missing benchmark_readiness block')
        block = match[2]
        for key, value in readiness.items():
            line = f'  {key}: '+json.dumps(value, ensure_ascii=False)
            pattern = re.compile(r'^  '+re.escape(key)+r':[^\n]*$', re.M)
            block = pattern.sub(lambda _: line, block) if pattern.search(block) else block+line+'\n'
        text = text[:match.start(2)]+block+text[match.end(2):]
        text = re.sub(r'Statut benchmark actuel\s*:\s*[^.;\n]+',
                      lambda _: 'Statut benchmark actuel : '+readiness['benchmark_status'], text)
        for field, key in [('Decision','benchmark_status'),('Manque principal','missing_items'),('Raison','reason')]:
            if re.search(r'^- '+field+':', text, re.M):text=set_bullet(text,field,readiness[key])
    if row.get('hold_estimators'):
        # Historical published-estimator evidence stays in the fiche; explicitly
        # suspend automatic benchmark use while the task is under review.
        status=row['readiness']['benchmark_status']
        block='## Estimator eligibility\n\n```yaml\nestimator_eligibility:\n'
        block+=f'  status: {json.dumps(status)}\n  eligible_estimators: []\n  conditionally_eligible_estimators: []\n'
        block+='  ineligible_reason: '+json.dumps(row['readiness']['reason'],ensure_ascii=False)+'\n'
        block+='  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."\n```\n'
        pattern=re.compile(r'^## Estimator eligibility\s*\n.*?(?=^## |\Z)',re.M|re.S)
        if pattern.search(text):text=pattern.sub(lambda _:block+'\n',text)
        else:text=text.replace('## Quality Control',block+'\n## Quality Control',1)
    # Keep former formulas (including damaged/paper prose) as historical evidence,
    # explicitly outside the active formula fields.
    note=row.get('note')
    if note:
        block='## Curation documentée — 2026-09-07\n\n'+note+'\n\n'
        pattern=re.compile(r'^## Curation documentée — 2026-09-07\n.*?(?=^## |\Z)',re.M|re.S)
        if pattern.search(text):text=pattern.sub(lambda _:block,text)
        else:text=text.rstrip()+'\n\n'+block
    # Whole reviewed sections are applied last so obsolete generator prose and
    # older field overrides cannot reintroduce a disproven published formula.
    if row.get('reviewed_preamble'):
        first_section = re.search(r'^## ', text, re.M)
        text = row['reviewed_preamble'].rstrip()+'\n\n'+text[first_section.start():]
    for heading, content in row.get('reviewed_sections', {}).items():
        pattern = re.compile(r'^## '+re.escape(heading)+r'\n.*?(?=^## |\Z)', re.M|re.S)
        block = '## '+heading+'\n\n'+content.strip()+'\n\n' if content else ''
        if pattern.search(text):
            text = pattern.sub(lambda _: block, text)
        elif content:
            text = text.rstrip()+'\n\n'+block
    if text != original:
        text=re.sub(r'^updated:.*$', 'updated: '+row.get('reviewed_date', '2026-09-07'), text, count=1, flags=re.M)
    return text.rstrip()+'\n'


def main() -> None:
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--files',nargs='*',type=Path)
    parser.add_argument('--check',action='store_true')
    args=parser.parse_args()
    paths=args.files or sorted((ROOT/'wiki/datasets/fiches_datasets').glob('*.md'))
    changed=[]
    for path in paths:
        before=path.read_text(encoding='utf-8');after=apply_curation(before,path.stem)
        if before != after:
            changed.append(path.stem)
            if not args.check:path.write_text(after,encoding='utf-8',newline='\n')
    print(json.dumps({'changed':len(changed),'examples':changed[:5]},ensure_ascii=False))
    if args.check and changed:raise SystemExit(1)


if __name__ == '__main__':main()
