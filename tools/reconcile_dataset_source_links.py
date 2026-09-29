"""Apply the source-link decisions verified during the 2026-09-07 audit.

Idempotent, preserving every unrelated KG record. Dataset-to-dataset provenance
is retained explicitly and must not be emitted as an article by the KG builder.
"""
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]


def reconcile(records):
    for row in records:
        if row.get('dataset_doi')=='10.5061/dryad.4xgxd259g' and row.get('paper_doi')=='10.5061/dryad.xgxd254bt':
            row.update({
                'paper_doi':None,'paper_id':'dataset:doi:10.5061/dryad.xgxd254bt',
                'source_entity_type':'Dataset','source_relation':'DERIVED_FROM',
                'related_dataset_doi':'10.5061/dryad.xgxd254bt',
                'publication_review_status':'pending_source_review',
                'source_ref':'Dryad 10.5061/dryad.4xgxd259g, Methods and Works referencing this dataset, checked 2026-09-07: Sugarglider.csv reuses Stojanovic (2019), dataset DOI 10.5061/dryad.xgxd254bt. This is a dataset relation, not an article DOI.',
                'evidence':'https://datadryad.org/dataset/doi%3A10.5061/dryad.4xgxd259g ; original dataset retained separately from the article link 10.1111/aec.12583.',
                'curation_date':'2026-09-07'})
    key='dataset:spatialtidymodels:paper_red_deer_topdown'
    if not any(x.get('canonical_dataset_id')==key for x in records):
        records.append({
            'paper_id':'paper:doi:10.1111/1365-2664.14526',
            'bib_key':'','paper_title':'Numerical top-down effects on red deer (Cervus elaphus) are mainly shaped by humans rather than large carnivores across Europe',
            'paper_doi':'10.1111/1365-2664.14526','dataset_doi':'10.5061/dryad.0cfxpnw7w',
            'dataset_name_in_paper':'Red deer density across European study sites',
            'canonical_dataset_id':key,'target_type':'Dataset','ingestion_status':'ingested',
            'package_include':'manual_review','benchmark_status':'manual_review',
            'source_type':'repository_related_publication_verified',
            'source_ref':'Local README + Dryad Works referencing this dataset, verified 2026-09-07.',
            'source_url':'https://doi.org/10.5061/dryad.0cfxpnw7w',
            'local_raw_dir':'data/raw/papers/DataCite_2023_NumericalTopdownEffectsOn_10_5061_dryad_0cfxpnw7w',
            'local_rds':'data/final_datasets/sf/paper_red_deer_topdown.rds',
            'evidence':'https://datadryad.org/dataset/doi%3A10.5061/dryad.0cfxpnw7w links the dataset to article DOI 10.1111/1365-2664.14526. 492 study sites in source; 534 RDS rows require reconciliation before benchmark.',
            'formula':None,'estimators_used':['GAM'],'confidence':'high',
            'curation_date':'2026-09-07'})
    return records


if __name__=='__main__':
    path=ROOT/'inst/kg/paper_dataset_uses.json'
    data=json.loads(path.read_text(encoding='utf-8'))
    before=json.dumps(data,sort_keys=True)
    data['records']=reconcile(data['records'])
    if json.dumps(data,sort_keys=True)!=before:
        path.write_text(json.dumps(data,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
    print(f"KG source relations: {len(data['records'])}; source links reconciled")
