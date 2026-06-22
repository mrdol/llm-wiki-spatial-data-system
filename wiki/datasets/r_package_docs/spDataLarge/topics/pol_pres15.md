Rdocumentation
powered by

Search all packages and functions
spDataLarge (version 2.2.0)

pol_pres15: Polish election data 2015

Polish election data 2015

Description

     Polish Presidential election 2015 data by gminy and Warsaw borough
     areal units

Usage

     pol_pres15

Format

     ‘sf’ data frame object with 2495 areal units and 65 variables

        * ‘TERYT’, ‘TERYT0’, ‘gm0’TERYT areal unit IDs

        * ‘name0’original areal unit names

        * ‘name’cleaned areal unit names

        * ‘types’factor with levels “Rural”, “Urban”, “Urban/rural” and
          “Warsaw borough”

        * ‘I_turnout’First round turnout proportion

        * ‘II_turnout’Runoff round turnout proportion

        * ‘I_Duda_share’Winner first round share

        * ‘II_Duda_share’Winner runoff round share

        * ‘I_Komorowski_share’Incumbent first round share

        * ‘II_Komorowski_share’Incumbent runoff round share

        * ‘I_*’First round aggregated counts of all polling station
          data

        * ‘II_*’Runoff round aggregated counts of all polling station
          data

Note:

     “PVE” in variable names means “postal voting envelopes”; voters
     requesting a postal voting package are expected to return a postal
     voting envelope with a declaration, and a sealed voting envelope
     to be placed in the ballot box.

Author(s):

     Roger Bivand

Source

     <http://prezydent2015.pkw.gov.pl/319_Pierwsze_glosowanie/>,
     <http://prezydent2015.pkw.gov.pl/325_Ponowne_glosowanie/>,
     <https://www.gov.pl/web/gugik>


Variables detected from installed object

TERYT: character ; missing=0 ; examples=020101, 020102, 020103

TERYT0: character ; missing=0 ; examples=020101, 020102, 020103

name0: character ; missing=0 ; examples=Miasto Bolesławiec, Bolesławiec - gmina, Gromadka

name: character ; missing=0 ; examples=BOLESŁAWIEC, GROMADKA

gm0: character ; missing=0 ; examples=020101, 020102, 020103

types: factor ; missing=0 ; examples=Urban, Rural

I_entitled_to_vote: integer ; missing=0 ; examples=31535, 10951, 4539

I_voting_papers_received: integer ; missing=0 ; examples=27140, 9390, 3907

I_unused_voting_papers: integer ; missing=0 ; examples=11991, 4614, 1943

I_voting_papers_issued_to_voters: integer ; missing=0 ; examples=15149, 4776, 1964

I_voters_voting_by_proxy: integer ; missing=0 ; examples=8, 0

I_voters_voting_by_declaration: integer ; missing=0 ; examples=79, 17, 8

I_voters_sent_postal_voting_package: integer ; missing=0 ; examples=7, 1

I_postal_voting_envelopes_received: integer ; missing=0 ; examples=7, 1

I_PVE_of_which_no_declaration: integer ; missing=0 ; examples=0

I_PVE_of_which_no_signature: integer ; missing=0 ; examples=0

I_PVE_of_which_no_voting_envelope: integer ; missing=0 ; examples=0

I_PVE_of_which_voting_envelope_open: integer ; missing=0 ; examples=0

I_voting_envelopes_placed_in_ballot_box: integer ; missing=0 ; examples=7, 1

I_voting_papers_taken_from_ballot_box: integer ; missing=0 ; examples=15152, 4777, 1965

I_of_which_voting_papers_taken_from_voting_envelopes: integer ; missing=0 ; examples=7, 1

I_invalid_voting_papers: integer ; missing=0 ; examples=3, 0

I_valid_voting_papers: integer ; missing=0 ; examples=15149, 4777, 1965

I_invalid_votes: integer ; missing=0 ; examples=110, 26, 22

I_valid_votes: integer ; missing=0 ; examples=15039, 4751, 1943

I_candidates_total: integer ; missing=0 ; examples=15039, 4751, 1943

I_Grzegorz.Michal.Braun: integer ; missing=0 ; examples=152, 53, 13

I_Andrzej.Sebastian.Duda: integer ; missing=0 ; examples=4018, 1489, 776

I_Adam.Sebastian.Jarubas: integer ; missing=0 ; examples=114, 59, 16

I_Bronislaw.Maria.Komorowski: integer ; missing=0 ; examples=6059, 1678, 669

I_Janusz.Ryszard.Korwin.Mikke: integer ; missing=0 ; examples=576, 180, 50

I_Marian.Janusz.Kowalski: integer ; missing=0 ; examples=68, 21, 4

I_Pawel.Piotr.Kukiz: integer ; missing=0 ; examples=3336, 1076, 338

I_Magdalena.Agnieszka.Ogorek: integer ; missing=0 ; examples=405, 121, 45

I_Janusz.Marian.Palikot: integer ; missing=0 ; examples=224, 50, 19

I_Pawel.Jan.Tanajno: integer ; missing=0 ; examples=19, 11, 1

I_Jacek.Wilk: integer ; missing=0 ; examples=68, 13, 12

II_entitled_to_vote: integer ; missing=0 ; examples=31458, 10950, 4514

II_voting_papers_received: integer ; missing=0 ; examples=27237, 9399, 3900

II_unused_voting_papers: integer ; missing=0 ; examples=10700, 3947, 1655

II_voting_papers_issued_to_voters: integer ; missing=0 ; examples=16537, 5452, 2245

II_voters_voting_by_proxy: integer ; missing=0 ; examples=9, 0, 2

II_voters_voting_by_declaration: integer ; missing=0 ; examples=172, 65, 18

II_voters_sent_postal_voting_package: integer ; missing=0 ; examples=12, 1

II_postal_voting_envelopes_received: integer ; missing=0 ; examples=10, 1

II_PVE_of_which_no_declaration: integer ; missing=0 ; examples=0

II_PVE_of_which_no_signature: integer ; missing=0 ; examples=0

II_PVE_of_which_no_voting_envelope: integer ; missing=0 ; examples=0

II_PVE_of_which_voting_envelope_open: integer ; missing=0 ; examples=0

II_voting_envelopes_placed_in_ballot_box: integer ; missing=0 ; examples=10, 1

II_voting_papers_taken_from_ballot_box: integer ; missing=0 ; examples=16544, 5453, 2246

II_of_which_voting_papers_taken_from_voting_envelopes: integer ; missing=0 ; examples=10, 1

II_invalid_voting_papers: integer ; missing=0 ; examples=0

II_valid_voting_papers: integer ; missing=0 ; examples=16544, 5453, 2246

II_invalid_votes: integer ; missing=0 ; examples=264, 67, 25

II_valid_votes: integer ; missing=0 ; examples=16280, 5386, 2221

II_Andrzej.Sebastian.Duda: integer ; missing=0 ; examples=6780, 2669, 1285

II_Bronislaw.Maria.Komorowski: integer ; missing=0 ; examples=9500, 2717, 936

geometry: sfc_MULTIPOLYGON/sfc ; missing=0

I_turnout: numeric ; missing=0 ; examples=0.476898684001903, 0.433841658296046, 0.428067856356026

II_turnout: numeric ; missing=0 ; examples=0.517515417381906, 0.491872146118721, 0.492024811696943

I_Duda_share: numeric ; missing=0 ; examples=0.267172019416185, 0.313407703641339, 0.399382398353062

II_Duda_share: numeric ; missing=0 ; examples=0.416461916461916, 0.495544002970665, 0.578568212516884

I_Komorowski_share: numeric ; missing=0 ; examples=0.402885830174879, 0.353188802357398, 0.344312918167782

II_Komorowski_share: numeric ; missing=0 ; examples=0.583538083538084, 0.504455997029335, 0.421431787483116

Examples
Run this code

     ## Not run:

     data("pol_pres15", package = "spDataLarge")
     wd = aggregate(pol_pres15$I_entitled_to_vote, list(pol_pres15$types), sum)$x
     boxplot(I_turnout ~ types, data = pol_pres15, width = wd)
     ## End(Not run)

