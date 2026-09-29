# Snapshot du noyau publiable

Date : **2026-09-27T16:19:22+02:00**  
Source : registre du package, 392 fiches et contrôle `check_dataset_fiche_readiness.py`.

## Résultat

| Niveau | Enregistrements | Familles parent--enfant | Sources déclarées distinctes |
|---|---:|---:|---:|
| Catalogue interne | 392 | non recalculé ici | non utilisé comme taille publiée |
| Admis dans le registre (`package_include=yes`) | 278 | 131 | 131 |
| Techniquement prêts après contrôle croisé | 276 | 129 | 129 |
| Licence vérifiée et redistribution autorisée | 0 | 0 | 0 |
| **Noyau actuellement publiable** | **0** | **0** | **0** |

Le noyau publiable est actuellement vide au sens strict. Ce résultat ne signifie
pas que les données sont fermées. Il signifie que les deux décisions
`license_verified=true` et `redistribution_allowed=true` n'ont encore été
enregistrées pour aucune entrée. Un nom de licence présent dans une fiche ne
remplace pas cette vérification.

## Contrôles techniques

- 278 artefacts candidats ont été localisés et soumis à un contrôle de
  présence, taille et signature de format ; formats : {'rds': 276, 'gpkg': 2}.
- 278 artefacts
  passent ce contrôle structurel de premier niveau.
- 277 fiches admises passent le gate documentaire.
- 276 entrées admises ont `benchmark_ready=true`.
- 276 entrées satisfont simultanément le statut `ready`, le gate
  documentaire, le drapeau `benchmark_ready`, l'intégrité du fichier, une
  réponse, des prédicteurs et une formule résolue.
- 276 entrées admises portent un nom de licence non vide et
  non `unknown`, mais aucune n'est encore juridiquement validée dans le registre.

## Couverture des 276 candidats techniquement prêts

| Champ | Nombre renseigné |
|---|---:|
| Réponse | 276 |
| Prédicteurs | 276 |
| Coordonnées déclarées | 37 |
| CRS déclaré | 272 |
| Plus d'une période | 43 |
| Panel spatial explicite | 12 |
| Référence à des poids spatiaux | 13 |

## File d'audit des licences au niveau des sources

| Licence déclarée | Sources distinctes à vérifier |
|---|---:|
| Creative Commons Zero v1.0 Universal | 73 |
| Creative Commons Attribution 4.0 International | 16 |
| BSD 3-Clause | 12 |
| GPL (>= 2) | 7 |
| GPL-2 | 4 |
| CC0 | 3 |
| Creative Commons Zero v1.0 Universal (CC0 1.0) | 2 |
| unknown | 2 |
| GPL (>= 2.0) | 2 |
| Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND) | 1 |
| Public Domain (U.S. Government work -- USGS) | 1 |
| Public Domain (U.S. Census Bureau data) | 1 |
| GNU General Public License v3.0 or later | 1 |
| probable CC0 1.0 (licence par defaut Dryad) -- a confirmer via la page Dataverse/Dryad du DOI | 1 |
| herite du parent [[paper_regulatory_convergence]] | 1 |
| Other/Open (Zenodo license.id = "other-open", no SPDX-recognized license text; source GitHub repo quexiang/STWR also declares no recognized license) | 1 |
| no defined terms of use -- contact dataset depositor before use | 1 |

La vérification doit être réalisée au niveau des 129 sources,
et non répétée pour leurs 276 enregistrements analytiques. Les
licences CC0 et CC BY 4.0 constituent la première priorité documentaire, car
elles couvrent la majorité des sources candidates. Les mentions `unknown`,
`probable`, `hérité du parent`, `other-open`, les licences sans texte reconnu
et les conditions imposant de contacter le déposant restent bloquantes jusqu'à
examen de la source officielle. Une licence de logiciel ne doit pas être
supposée couvrir automatiquement un fichier de données sans preuve.

## Incohérences bloquant deux admissions

- `paper_leishmaniasis_occurrence` porte `package_include=yes` et
  `benchmark_status=ready`, mais `benchmark_ready=false` à cause d'une typologie
  de réponse encore signalée comme non résolue.
- `R_gstat_DE_RB_2005_DE_RB_2005` porte les drapeaux de préparation, mais sa
  fiche échoue au gate car le bloc d'éligibilité des estimateurs manque.

## Décision pour le manuscrit

Les nombres 392 et 278 ne doivent pas remplir les champs du résumé ou de
`Data Records`. Le manuscrit peut décrire le protocole et signaler
276 candidats techniquement prêts, mais la taille de la banque
publiée restera indéterminée jusqu'à l'audit des licences et des droits de
redistribution. Après cet audit, le présent script devra être relancé sans
modifier manuellement le TSV.

Le détail des 278 admissions se trouve dans `snapshot_noyau_publiable_2026-09-27.tsv`.
