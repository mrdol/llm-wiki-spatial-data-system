# Human Review Grid - Quality Pedigree

Cette grille sert a valider humainement une evaluation `quality_pedigree` proposee par le LLM.

Le LLM peut proposer les notes, mais ne doit pas decider seul du statut `reviewed`.

## Fiche Evaluee

- Page ou record:
- Type: dataset / paper / warehouse / source / estimator / analysis
- Evaluateur humain:
- Date:

## Scores

| Critere | Score propose par le LLM | Score humain | Commentaire humain |
|---|---:|---:|---|
| Provenance |  |  |  |
| Rigueur |  |  |  |
| Evidence |  |  |  |
| Coherence |  |  |  |
| Discipline des affirmations |  |  |  |

## Citation Metrics

| Champ | Valeur proposee | Validation humaine |
|---|---|---|
| Dataset citation count |  |  |
| Paper citation count |  |  |
| Source de citation | OpenAlex / DataCite / Crossref / manuel / non verifie |  |
| Date de verification |  |  |
| Interpretation | no / weak / moderate / strong / very strong / ambiguous |  |

Questions de revue:

- Les citations concernent-elles le dataset, le papier, ou seulement une source voisine ?
- Le dataset est-il recent, ce qui rend un faible nombre de citations normal ?
- Les citations justifient-elles seulement l'usage de la source, ou aussi sa qualite methodologique ?
- Le score `evidence_score` reste-t-il justifie par autre chose que les citations ?

## Controle Delta1

- Le LLM evalue-t-il un contenu qu'il a lui-meme produit ?
- Les preuves viennent-elles d'une source externe verifiable ?
- Faut-il baisser un score a cause d'un risque d'auto-evaluation ?

## Decision

Statut final:

- [ ] `pending`
- [ ] `needs_revision`
- [ ] `reviewed`
- [ ] `rejected`

Corrections demandees:

-

## Regle

Ne passer a `reviewed` que si un humain identifie accepte les scores ou les corrige explicitement.
