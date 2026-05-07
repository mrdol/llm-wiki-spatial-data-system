# Example Manual Review - Quality Pedigree

## Fiche Evaluee

- Page ou record: `warehouse:world_bank`
- Type: warehouse
- Evaluateur humain: a completer
- Date: 2026-05-05

## Scores

| Critere | Score propose par le LLM | Score humain | Commentaire humain |
|---|---:|---:|---|
| Provenance | 4 |  | Source institutionnelle internationale identifiable. |
| Rigueur | 3 |  | Methodologie solide au niveau source, mais chaque dataset doit etre controle separement. |
| Evidence | 4 |  | API, portail, documentation et conditions d'utilisation existent. |
| Coherence | 4 |  | Le record local est coherent avec le role de la source. |
| Discipline des affirmations | 3 |  | Ne pas inferer qu'un indicateur World Bank convient a une modelisation spatiale sans inspection dataset. |

## Citation Metrics

| Champ | Valeur proposee | Validation humaine |
|---|---|---|
| Dataset citation count | Non applicable au niveau entrepot |  |
| Paper citation count | Non applicable au niveau entrepot |  |
| Source de citation | none |  |
| Date de verification | null |  |
| Interpretation | not_applicable |  |

Les citations sont utiles au niveau dataset ou papier. Au niveau entrepot, elles ne doivent pas influencer directement le score.

## Controle Delta1

- Le LLM propose l'evaluation.
- La validation finale reste humaine.
- Le statut doit rester `pending` tant que l'encadreur ou l'utilisateur n'a pas confirme.

## Decision

Statut final:

- [x] `pending`
- [ ] `needs_revision`
- [ ] `reviewed`
- [ ] `rejected`

Corrections demandees:

- Aucune pour l'exemple; revue humaine non encore faite.
