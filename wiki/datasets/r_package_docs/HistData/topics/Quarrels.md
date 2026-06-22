Rdocumentation
powered by

Search all packages and functions
HistData (version 1.0.0)

Statistics of Deadly Quarrels

Description

     _The Statistics Of Deadly Quarrels_ by Lewis Fry Richardson (1960)
     is one of the earlier attempts at quantification of historical
     conflict behavior.

     The data set contains 779 dyadic deadly quarrels that cover a time
     period from 1809 to 1949.  A quarrel consists of one pair of
     belligerents, and is identified by its beginning date and
     magnitude (log 10 of the number of deaths). Neither actor in a
     quarrel is identified by name.

     Because Richardson took a dyad of belligerents as his unit, a
     given war, such as World War I or World War II comprises multiple
     observations, for all pairs of belligerents.  For example, there
     are forty-four pairs of belligerents coded for World War I.

     For each quarrel, the nominal variables include the type of
     quarrel, as well as political, cultural, and economic similarities
     and dissimilarities between the pair of combatants.

Format

     A data frame with 779 observations on the following 84 variables.

     ‘ID ’ V84: Id sequence

     ‘year ’ V1: Begin date of quarrel

     ‘international’ V2: Nation vs nation

     ‘colonial’ V3: Nation vs colony

     ‘revolution ’ V4: Revolution or civil war

     ‘nat.grp’ V5: Nation vs gp in other nation

     ‘grp.grpSame ’ V6: Grp vs grp (same nation)

     ‘grp.grpDif’ V7: Grp vs grp (between nations)

     ‘numGroups’ V8: Number groups against which fighting

     ‘months’ V9: Number months fighting

     ‘pairs’ V10: Number pairs in whole matrix

     ‘monthsPairs’ V11: Num mons for all in matrix

     ‘logDeaths ’ V12: Log (killed) matrix

     ‘deaths ’ V13: Total killed for matrix

     ‘exchangeGoods ’ V14: Gp sent goods to other

     ‘obstacleGoods ’ V15: Gp puts obstacles to goods

     ‘intermarriageOK ’ V16: Present intermarriages

     ‘intermarriageBan ’ V17: Intermarriages banned

     ‘simBody ’ V18: Similar body characteristics

     ‘difBody ’ V19: Difference in body characteristics

     ‘simDress ’ V20: Similarity of customs (dress)

     ‘difDress ’ V21: Difference of customs (dress)

     ‘eqWealth ’ V22: Common level of wealth

     ‘difWealth ’ V23: Difference in wealth

     ‘simMariagCust ’ V24: Similar marriage customst

     ‘difMariagCust ’ V25: Different marriage customs

     ‘simRelig ’ V26: Similar religion or philosophy of life

     ‘difRelig ’ V27: Religion or philosophy felt different

     ‘philanthropy ’ V28: General philanthropy

     ‘restrictMigration ’ V29: Restricted immigrations

     ‘sameLanguage ’ V30: Common mother tongue

     ‘difLanguage ’ V31: Different languages

     ‘simArtSci ’ V32: Similar science, arts

     ‘travel ’ V33: Travel

     ‘ignorance ’ V34: Ignorant of other/both

     ‘simPersLiberty ’ V35: Personal liberty similar

     ‘difPersLiberty ’ V36: More personal liberty

     ‘sameGov ’ V37: Common government

     ‘sameGovYrs ’ V38: Years since common govt established

     ‘prevConflict ’ V39: Belligerents fought previously

     ‘prevConflictYrs ’ V40: Years since belligerents fought

     ‘chronicFighting ’ V41: Chronic fighting between belligerents

     ‘persFriendship ’ V42: Autocrats personal friends

     ‘persResentment ’ V43: Leaders personal resentment

     ‘difLegal ’ V44: Annoyingly different legal systems

     ‘nonintervention ’ V45: Policy of nonintervention

     ‘thirdParty ’ V46: Led by 3rd group to conflict

     ‘supportEnemy ’ V47: Supported others enemy

     ‘attackAlly ’ V48: Attacked ally of other

     ‘rivalsLand ’ V49: Rivals territory concess

     ‘rivalsTrade ’ V50: Rivals trade

     ‘churchPower ’ V51: Church civil power

     ‘noExtension ’ V52: Policy not extending term

     ‘territory ’ V53: Desired territory

     ‘habitation ’ V54: Wanted habitation

     ‘minerals ’ V55: Desired minerals

     ‘StrongHold ’ V56: Wanted strategic stronghold

     ‘taxation ’ V57: Taxed other

     ‘loot ’ V58: Wanted loot

     ‘objectedWar ’ V59: Objected to war

     ‘enjoyFight ’ V60: Enjoyed fighting

     ‘pride ’ V61: Elated by strong pride

     ‘overpopulated ’ V62: Insufficient land for population

     ‘fightForPay ’ V63: Fought only for pay

     ‘joinWinner ’ V64: Desired to join winners

     ‘otherDesiredWar ’ V65: Quarrel desired by other

     ‘propaganda3rd ’ V66: Issued of propaganda to third parties

     ‘protection ’ V67: Offered protection

     ‘sympathy ’ V68: Sympathized under control

     ‘debt ’ V69: Owed money to others

     ‘prevAllies ’ V70: Had fought as allies

     ‘yearsAllies ’ V71: Years since fought as allies

     ‘intermingled ’ V72: Had intermingled on territory

     ‘interbreeding ’ V73: Interbreeding between groups

     ‘propadanda ’ V74: Issued propaganda to other group

     ‘orderedObey ’ V75: Ordered other to obey

     ‘commerceOther ’ V76: Commercial enterprises

     ‘feltStronger ’ V77: Felt stronger

     ‘competeIntellect ’ V78: Competed successfully intellectual occ

     ‘insecureGovt ’ V79: Government insecure

     ‘prepWar ’ V80: Preparations for war

     ‘RegionalError ’ V81: Regional error measure

     ‘CasualtyError ’ V82: Casualty error measure

     ‘Auxiliaries ’ V83: Auxiliaries in service of nation at war

Details

     In the original data set obtained from ICPSR, variables were named
     ‘V1’-‘V84’.  These were renamed to make them more meaningful.
     ‘V84’, renamed ‘ID’ was moved to the first position, but otherwise
     the order of variables is the same.

     In many of the ‘factor’ variables, ‘0’ is used to indicate
     "irrelevant to quarrel".  This refers to those relations that
     Richardson found absent or irrelevant to the particular quarrel,
     and did not subsequently mention.

     See the original codebook at
     <http://www.icpsr.umich.edu/cgi-bin/file?comp=none&study=5407&ds=1&file_id=652814>
     for details not contained here.

Source

     <http://www.icpsr.umich.edu/icpsrweb/ICPSR/studies/05407>

References

     Lewis F. Richardson, (1960). _The Statistics Of Deadly Quarrels_.
     (Edited by Q. Wright and C. C. Lienau).  Pittsburgh: Boxwood
     Press.

     Rummel, Rudolph J. (1967), "Dimensions of Dyadic War, 1820-1952."
     _Journal of Conflict Resolution_. *11*, (2), 176 - 183.


Variables detected from installed object

ID: integer ; missing=0 ; examples=1, 2, 3

year: integer ; missing=0 ; examples=1914

international: integer ; missing=0 ; examples=1

colonial: integer ; missing=0 ; examples=0

revolution: integer ; missing=0 ; examples=0

nat.grp: integer ; missing=0 ; examples=0

grp.grpSame: integer ; missing=0 ; examples=0

grp.grpDif: integer ; missing=0 ; examples=0

numGroups: integer ; missing=0 ; examples=16, 17

months: integer ; missing=0 ; examples=52, 43

pairs: integer ; missing=0 ; examples=44

monthsPairs: integer ; missing=0 ; examples=1436

logDeaths: numeric ; missing=0 ; examples=7.2

deaths: integer ; missing=0 ; examples=15900000

exchangeGoods: factor ; missing=0 ; examples=0

obstacleGoods: factor ; missing=0 ; examples=1, 0

intermarriageOK: factor ; missing=0 ; examples=0

intermarriageBan: factor ; missing=0 ; examples=0

simBody: factor ; missing=0 ; examples=0

difBody: factor ; missing=0 ; examples=0

simDress: factor ; missing=0 ; examples=0

difDress: factor ; missing=0 ; examples=0

eqWealth: factor ; missing=0 ; examples=0

difWealth: factor ; missing=0 ; examples=0

simMariagCust: factor ; missing=0 ; examples=0

difMariagCust: factor ; missing=0 ; examples=0

simRelig: factor ; missing=0 ; examples=0, 1

difRelig: factor ; missing=0 ; examples=0

philanthropy: factor ; missing=0 ; examples=0

restrictMigration: factor ; missing=0 ; examples=0

sameLanguage: factor ; missing=0 ; examples=0

difLanguage: factor ; missing=0 ; examples=1

simArtSci: factor ; missing=0 ; examples=0

travel: factor ; missing=0 ; examples=0

ignorance: factor ; missing=0 ; examples=0

simPersLiberty: factor ; missing=0 ; examples=0

difPersLiberty: factor ; missing=0 ; examples=0

sameGov: factor ; missing=0 ; examples=0

sameGovYrs: integer ; missing=0 ; examples=0

prevConflict: factor ; missing=0 ; examples=0, 1

prevConflictYrs: integer ; missing=0 ; examples=0, 55

chronicFighting: factor ; missing=0 ; examples=0

persFriendship: factor ; missing=0 ; examples=0

persResentment: factor ; missing=0 ; examples=0

difLegal: factor ; missing=0 ; examples=0

nonintervention: factor ; missing=0 ; examples=0

thirdParty: factor ; missing=0 ; examples=0

supportEnemy: factor ; missing=0 ; examples=0

attackAlly: factor ; missing=0 ; examples=0

rivalsLand: factor ; missing=0 ; examples=0

rivalsTrade: factor ; missing=0 ; examples=0

churchPower: factor ; missing=0 ; examples=0

noExtension: factor ; missing=0 ; examples=0

territory: factor ; missing=0 ; examples=0

habitation: factor ; missing=0 ; examples=0

minerals: factor ; missing=0 ; examples=0

StrongHold: factor ; missing=0 ; examples=0

taxation: factor ; missing=0 ; examples=0

loot: factor ; missing=0 ; examples=0

objectedWar: factor ; missing=0 ; examples=0

enjoyFight: factor ; missing=0 ; examples=0

pride: factor ; missing=0 ; examples=0

overpopulated: factor ; missing=0 ; examples=0

fightForPay: factor ; missing=0 ; examples=0

joinWinner: factor ; missing=0 ; examples=0

otherDesiredWar: factor ; missing=0 ; examples=0

propaganda3rd: factor ; missing=0 ; examples=0

protection: factor ; missing=0 ; examples=0

sympathy: factor ; missing=0 ; examples=1, 0

debt: factor ; missing=0 ; examples=0

prevAllies: factor ; missing=0 ; examples=0, 1

yearsAllies: integer ; missing=0 ; examples=0, 14

intermingled: factor ; missing=0 ; examples=0

interbreeding: factor ; missing=0 ; examples=0

propadanda: factor ; missing=0 ; examples=0

orderedObey: factor ; missing=0 ; examples=0

commerceOther: factor ; missing=0 ; examples=0

feltStronger: factor ; missing=0 ; examples=0

competeIntellect: factor ; missing=0 ; examples=0

insecureGovt: factor ; missing=0 ; examples=0

prepWar: factor ; missing=0 ; examples=0, 2

RegionalError: integer ; missing=0 ; examples=3

CasualtyError: integer ; missing=0 ; examples=3

Auxiliaries: integer ; missing=0 ; examples=2

Examples
Run this code

     data(Quarrels)
     str(Quarrels)

