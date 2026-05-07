---
title: Quality Pedigree Schema v1
type: metadata
created: 2026-05-05
updated: 2026-05-05
sources:
  - https://www.yatesweb.com/adding-quality-control-to-andrej-karpathys-llm-wiki/
  - https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
tags: [metadata, quality-control, pedigree, nusap, human-review]
---

Schema de controle qualite pour distinguer les sources robustes des sources faibles dans le LLM Wiki.

## Objectif

La matrice `quality_pedigree` ajoute une couche de controle qualite aux datasets, papiers, sources et entrepots. Elle evite qu'une page bien redigee par le LLM paraisse fiable sans preuve.

Le principe vient de l'article de Mick Yates sur le controle qualite du LLM Wiki de Karpathy, avec une inspiration NUSAP: une information doit porter son origine, son incertitude, son niveau de preuve et son statut de revue humaine.

## Bloc Machine

Chaque record valide doit pouvoir porter un bloc de ce type:

```yaml
quality_pedigree:
  provenance: official_warehouse
  provenance_score: 4
  provenance_evidence: "Source produite par un entrepot officiel avec producteur identifiable."
  rigour_score: 3
  rigour_evidence: "Documentation disponible, mais methodologie complete a verifier."
  evidence_score: 4
  evidence_evidence: "DOI, URL, licence, metadata ou papier associe documentes."
  coherence_score: 4
  coherence_evidence: "Les champs locaux sont coherents avec la source documentee."
  claim_discipline_score: 3
  claim_discipline_evidence: "Les claims restent prudents; aucune conclusion modelisee non verifiee."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_applicable
    citation_evidence: "Aucun DOI dataset ou papier actif a verifier dans ce record."
  delta1_risk: low
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
  reviewer: null
  reviewed_at: null
  reference_schema: wiki/metadata/quality_pedigree_schema_v1.md
```

## Regle Importante

Un score seul ne suffit jamais.

Chaque score doit avoir son champ `*_evidence` correspondant. Exemple:

- `provenance_score` doit avoir `provenance_evidence`
- `rigour_score` doit avoir `rigour_evidence`
- `evidence_score` doit avoir `evidence_evidence`
- `coherence_score` doit avoir `coherence_evidence`
- `claim_discipline_score` doit avoir `claim_discipline_evidence`

Les citations peuvent enrichir `evidence_score`, mais elles ne doivent jamais remplacer la preuve directe: DOI, licence, documentation, code, metadata, papier, et coherence locale.

## Echelle Des Scores

Tous les scores vont de 1 a 5.

| Score | Sens |
|---|---|
| 5 | Tres fort, directement documente, verifiable, robuste |
| 4 | Fort, bien documente, faibles incertitudes residuelles |
| 3 | Moyen, exploitable mais verification ou enrichissement necessaire |
| 2 | Faible, documentation partielle ou source fragile |
| 1 | Tres faible, non verifie ou insuffisant pour appuyer une decision |

## Provenance

La provenance mesure d'ou vient l'information.

| Score | Interpretation |
|---|---|
| 5 | Article peer-reviewed, entrepot officiel ou source primaire avec DOI, licence, producteur et version explicites |
| 4 | Entrepot officiel ou institutionnel avec producteur clair, mais documentation partielle |
| 3 | Source identifiable et stable, mais licence, version ou producteur incomplet |
| 2 | Source secondaire ou page peu documentee |
| 1 | Source non traçable ou non verifiable |

Valeurs recommandees pour `provenance`:

- `official_warehouse`
- `research_repository`
- `software_package`
- `peer_reviewed_paper`
- `institutional_page`
- `secondary_source`
- `unknown`

## Rigueur

La rigueur mesure la solidite methodologique de la source.

| Score | Interpretation |
|---|---|
| 5 | Methodologie complete, code ou protocole reproductible, validation claire |
| 4 | Methodologie solide et documentee, quelques details manquants |
| 3 | Methodologie lisible mais incomplete ou non testee localement |
| 2 | Methodologie faible, implicite ou non reproductible |
| 1 | Pas de methode exploitable |

## Evidence

L'evidence mesure le niveau de preuve disponible derriere l'information.

| Score | Interpretation |
|---|---|
| 5 | Donnees, DOI, licence, documentation, papier et code convergent |
| 4 | Plusieurs preuves convergent, mais pas toutes les pieces sont presentes |
| 3 | Metadata et source disponibles, mais papier, code ou licence restent incomplets |
| 2 | Une seule preuve fragile |
| 1 | Assertion sans preuve documentee |

## Citation Metrics

Les citations mesurent l'usage ou la visibilite academique d'un dataset ou d'un papier. Elles enrichissent la decision, mais ne prouvent pas a elles seules la qualite.

Bloc recommande:

```yaml
citation_metrics:
  dataset_citation_count: null
  paper_citation_count: null
  citation_source: openalex
  citation_checked_at: 2026-05-05
  citation_url: "https://openalex.org/..."
  citation_interpretation: moderate_signal
  citation_evidence: "OpenAlex cited_by_count releve pour le DOI du papier associe."
```

Sources autorisees pour `citation_source`:

- `openalex`
- `datacite`
- `crossref`
- `manual_review`
- `none`
- `unknown`

Valeurs autorisees pour `citation_interpretation`:

- `not_applicable`: pas de DOI ou pas de contexte bibliometrique utile
- `not_checked`: DOI present mais citations non verifiees
- `no_signal`: 0 citation, sans penalite automatique
- `weak_signal`: 1 a 10 citations
- `moderate_signal`: 11 a 50 citations
- `strong_signal`: 51 a 200 citations
- `very_strong_signal`: plus de 200 citations
- `ambiguous`: signal difficile a interpreter

### Regles D'Interpretation

- Un nombre eleve de citations peut augmenter la confiance dans l'usage de la source, mais pas remplacer la verification de licence, variables, format, methode et coherence.
- Un nombre faible de citations ne doit pas penaliser automatiquement un dataset recent, institutionnel ou tres specialise.
- Les citations doivent etre datees avec `citation_checked_at`, car elles evoluent.
- `citation_source` doit indiquer d'ou vient le chiffre: OpenAlex, DataCite, Crossref ou revue manuelle.
- Les citations d'un papier associe ne sont pas forcement les citations du dataset. Garder `paper_citation_count` et `dataset_citation_count` separes.
- Si le LLM n'a pas verifie les citations en ligne, utiliser `citation_source: none` ou `unknown` et `citation_interpretation: not_checked`.

### Effet Sur La Decision

Les citations peuvent seulement enrichir:

- `evidence_evidence`: en ajoutant un signal d'usage documente;
- `claim_discipline_evidence`: en rappelant les limites de ce signal;
- la decision humaine finale.

Elles ne doivent pas automatiquement transformer un record en `reviewed`.

## Coherence

La coherence mesure si les informations locales ne se contredisent pas.

| Score | Interpretation |
|---|---|
| 5 | Catalogue, fiche wiki, manifest, DOI et source externe sont alignes |
| 4 | Alignement global, quelques champs a completer |
| 3 | Pas de contradiction visible, mais verification incomplete |
| 2 | Tensions ou champs ambigus |
| 1 | Contradiction manifeste entre sources |

## Claim Discipline

La discipline des affirmations mesure si le LLM ou la fiche ne dit pas plus que les preuves.

| Score | Interpretation |
|---|---|
| 5 | Les conclusions sont strictement limitees aux preuves documentees |
| 4 | Les conclusions sont prudentes, avec incertitudes explicites |
| 3 | Claims globalement prudents, mais certains points demandent revue humaine |
| 2 | Claims trop forts par rapport aux preuves |
| 1 | Hallucination probable ou conclusion non supportee |

## Regle Delta1

La regle Delta1 vient de l'idee mentionnee par Mick Yates: l'instrument de mesure doit rester separe de l'objet mesure.

Dans ce systeme:

- le LLM peut proposer une evaluation;
- le LLM ne doit pas marquer seul `review_status: reviewed`;
- la validation finale doit etre faite par l'utilisateur ou l'encadreur;
- tout score propose par le LLM doit rester `pending` tant qu'aucun humain n'a valide.

Valeurs autorisees pour `delta1_risk`:

- `low`: source externe et verifiable; le LLM ne s'evalue pas lui-meme
- `medium`: evaluation partiellement fondee sur resume ou extraction LLM
- `high`: le LLM juge principalement un contenu qu'il a lui-meme produit
- `not_applicable`: fiche purement technique ou schema sans claim empirique

## Statuts De Revue

| Statut | Sens |
|---|---|
| `pending` | Le LLM a propose l'evaluation, mais l'humain n'a pas encore tranche |
| `needs_revision` | L'humain a trouve des problemes ou demande correction |
| `reviewed` | Un humain a valide l'evaluation |
| `rejected` | La source ou la fiche ne doit pas etre utilisee comme base fiable |

## Interaction Homme-LLM

Le comportement attendu est:

1. Le LLM lit les sources disponibles.
2. Le LLM propose les scores et justifications.
3. Le LLM indique les incertitudes.
4. Le LLM demande explicitement l'avis de l'utilisateur pour valider ou corriger.
5. Seul l'utilisateur ou l'encadreur peut faire passer `review_status` a `reviewed`.

## Related Pages

- [[catalog_registry_schema_v3]]
- [[discovery_policy_v3]]
- [[dataset_catalog_schema_v2]]
