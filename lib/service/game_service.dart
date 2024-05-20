import 'package:app/models/game.dart';

class GameService {
  Future<List<Game>> get getData async {
    await Future.delayed(const Duration(seconds: 1));
    return games
        .map((e) => Game.fromJson(e))
        .toList()
        .where((element) => element.dateGame != null)
        .toList();
  }

  Future<Game> getGame(String id) async {
    return (await getData).where((element) => element.idGame == id).toList()[0];
  }

  Future<List<Game>> getGamesBy(
      {String? idGroupe,
      String? codeNiveau,
      String? codeEdition,
      String? dateGame}) async {
    List<Game> liste = await getData;
    if (idGroupe != null) {
      liste = liste.where((element) => element.idGroupe == idGroupe).toList();
    }
    if (codeNiveau != null) {
      liste =
          liste.where((element) => element.codeNiveau == codeNiveau).toList();
    }
    if (codeEdition != null) {
      liste =
          liste.where((element) => element.codeEdition == codeEdition).toList();
    }
    if (dateGame != null) {
      liste = liste.where((element) => element.dateGame == dateGame).toList();
    }
    return liste;
  }
}

const games = [
  {
    "idGame": 1,
    "idHome": "25",
    "idAway": "26",
    "dateGame": "2023-08-06",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 9,
    "home": "FC Yakaaré Django",
    "away": "FC Yakaaré",
    "homeScore": 2,
    "awayScore": 0,
    "nomGroupe": "A",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 3,
    "idHome": "30",
    "idAway": "31",
    "dateGame": "2023-08-08",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 10,
    "home": "FC Piindi Bamtaaré",
    "away": "FC Lewlewal",
    "homeScore": 2,
    "awayScore": 0,
    "nomGroupe": "B",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 4,
    "idHome": "27",
    "idAway": "28",
    "dateGame": "2023-08-09",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 9,
    "home": "FC Hodere Yontaabé",
    "away": "FC Hoderé Bamtaaré",
    "homeScore": 0,
    "awayScore": 1,
    "nomGroupe": "A",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 32,
    "idHome": "32",
    "idAway": "33",
    "dateGame": "2023-08-10",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 10,
    "home": "FC Union",
    "away": "FC Foyré Bamtaaré",
    "homeScore": 0,
    "awayScore": 3,
    "nomGroupe": "B",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 48,
    "idHome": "34",
    "idAway": "30",
    "dateGame": "2023-08-14",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 10,
    "home": "FC Abou Sem",
    "away": "FC Piindi Bamtaaré",
    "homeScore": 1,
    "awayScore": 6,
    "nomGroupe": "B",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 33,
    "idHome": "29",
    "idAway": "25",
    "dateGame": "2023-08-15",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 9,
    "home": "FC Véterans",
    "away": "FC Yakaaré Django",
    "homeScore": 0,
    "awayScore": 7,
    "nomGroupe": "A",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 34,
    "idHome": "27",
    "idAway": "26",
    "dateGame": "2023-08-16",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 9,
    "home": "FC Hodere Yontaabé",
    "away": "FC Yakaaré",
    "homeScore": 4,
    "awayScore": 0,
    "nomGroupe": "A",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr2",
    "nomNiveau": "tour 2",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 43,
    "idHome": "31",
    "idAway": "32",
    "dateGame": "2023-08-17",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 10,
    "home": "FC Lewlewal",
    "away": "FC Union",
    "homeScore": 3,
    "awayScore": 1,
    "nomGroupe": "B",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr2",
    "nomNiveau": "tour 2",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 36,
    "idHome": "28",
    "idAway": "29",
    "dateGame": "2023-08-18",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 9,
    "home": "FC Hoderé Bamtaaré",
    "away": "FC Véterans",
    "homeScore": 3,
    "awayScore": 2,
    "nomGroupe": "A",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr2",
    "nomNiveau": "tour 2",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 71,
    "idHome": "33",
    "idAway": "34",
    "dateGame": "2023-08-19",
    "stadeGame": "Stade de thialgou",
    "heureGame": "17:00",
    "idGroupe": 10,
    "home": "FC Foyré Bamtaaré",
    "away": "FC Abou Sem",
    "homeScore": 3,
    "awayScore": 2,
    "nomGroupe": "B",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr2",
    "nomNiveau": "tour 2",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 37,
    "idHome": "25",
    "idAway": "27",
    "dateGame": "2023-08-23",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 9,
    "home": "FC Yakaaré Django",
    "away": "FC Hodere Yontaabé",
    "homeScore": 1,
    "awayScore": 0,
    "nomGroupe": "A",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr3",
    "nomNiveau": "tour 3",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 39,
    "idHome": "26",
    "idAway": "28",
    "dateGame": "2023-08-25",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 9,
    "home": "FC Yakaaré",
    "away": "FC Hoderé Bamtaaré",
    "homeScore": 0,
    "awayScore": 3,
    "nomGroupe": "A",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr3",
    "nomNiveau": "tour 3",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 38,
    "idHome": "31",
    "idAway": "33",
    "dateGame": "2023-08-27",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:30",
    "idGroupe": 10,
    "home": "FC Lewlewal",
    "away": "FC Foyré Bamtaaré",
    "homeScore": 0,
    "awayScore": 0,
    "nomGroupe": "B",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr3",
    "nomNiveau": "tour 3",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 72,
    "idHome": "34",
    "idAway": "32",
    "dateGame": "2023-08-29",
    "stadeGame": "Stade de thialgou",
    "heureGame": "17:00",
    "idGroupe": 10,
    "home": "FC Abou Sem",
    "away": "FC Union",
    "homeScore": 0,
    "awayScore": 1,
    "nomGroupe": "B",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr3",
    "nomNiveau": "tour 3",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 40,
    "idHome": "29",
    "idAway": "27",
    "dateGame": "2023-09-03",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 9,
    "home": "FC Véterans",
    "away": "FC Hodere Yontaabé",
    "homeScore": 6,
    "awayScore": 1,
    "nomGroupe": "A",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr3",
    "nomNiveau": "tour 3",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 35,
    "idHome": "30",
    "idAway": "32",
    "dateGame": "2023-09-06",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 10,
    "home": "FC Piindi Bamtaaré",
    "away": "FC Union",
    "homeScore": 2,
    "awayScore": 2,
    "nomGroupe": "B",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr3",
    "nomNiveau": "tour 3",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 41,
    "idHome": "33",
    "idAway": "30",
    "dateGame": "2023-09-13",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 10,
    "home": "FC Foyré Bamtaaré",
    "away": "FC Piindi Bamtaaré",
    "homeScore": 1,
    "awayScore": 4,
    "nomGroupe": "B",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr4",
    "nomNiveau": "tour 4",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 42,
    "idHome": "25",
    "idAway": "28",
    "dateGame": "2023-09-14",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 9,
    "home": "FC Yakaaré Django",
    "away": "FC Hoderé Bamtaaré",
    "homeScore": 1,
    "awayScore": 2,
    "nomGroupe": "A",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr4",
    "nomNiveau": "tour 4",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 77,
    "idHome": "34",
    "idAway": "31",
    "dateGame": "2023-09-15",
    "stadeGame": "Stade de thialgou",
    "heureGame": "17:00",
    "idGroupe": 10,
    "home": "FC Abou Sem",
    "away": "FC Lewlewal",
    "homeScore": 0,
    "awayScore": 2,
    "nomGroupe": "B",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr4",
    "nomNiveau": "tour 4",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 44,
    "idHome": "26",
    "idAway": "29",
    "dateGame": "2023-09-18",
    "stadeGame": "Stade de thialgou",
    "heureGame": "17:00",
    "idGroupe": 9,
    "home": "FC Yakaaré",
    "away": "FC Véterans",
    "homeScore": 3,
    "awayScore": 1,
    "nomGroupe": "A",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr4",
    "nomNiveau": "tour 4",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 78,
    "idHome": "28",
    "idAway": "31",
    "dateGame": "2023-09-19",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 12,
    "home": "FC Hoderé Bamtaaré",
    "away": "FC Lewlewal",
    "homeScore": 1,
    "awayScore": 1,
    "nomGroupe": "C",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "df",
    "codeNiveau": "df",
    "nomNiveau": "Demi-finale",
    "nomPhase": "Demi-finale",
    "typePhase": "elimination",
    "homeScorePenalty": 5,
    "awayScorePenalty": 6
  },
  {
    "idGame": 79,
    "idHome": "30",
    "idAway": "25",
    "dateGame": "2023-09-20",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "17:00",
    "idGroupe": 12,
    "home": "FC Piindi Bamtaaré",
    "away": "FC Yakaaré Django",
    "homeScore": 2,
    "awayScore": 0,
    "nomGroupe": "C",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "df",
    "codeNiveau": "df",
    "nomNiveau": "Demi-finale",
    "nomPhase": "Demi-finale",
    "typePhase": "elimination",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 80,
    "idHome": "31",
    "idAway": "30",
    "dateGame": "2023-09-26",
    "stadeGame": "Stade de Thialgou",
    "heureGame": "16:00",
    "idGroupe": 13,
    "home": "FC Lewlewal",
    "away": "FC Piindi Bamtaaré",
    "homeScore": 0,
    "awayScore": 3,
    "nomGroupe": "D",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "codePhase": "fn",
    "codeNiveau": "fn",
    "nomNiveau": "Finale",
    "nomPhase": "Finale",
    "typePhase": "elimination",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 67,
    "idHome": "15",
    "idAway": "13",
    "dateGame": "2024-05-20",
    "stadeGame": "Stade de Thidé",
    "heureGame": "16:00",
    "idGroupe": 5,
    "home": "FC Inter",
    "away": "FC Sayé",
    "homeScore": null,
    "awayScore": null,
    "nomGroupe": "E",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr2",
    "nomNiveau": "tour 2",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 45,
    "idHome": "1",
    "idAway": "3",
    "dateGame": "2023-08-05",
    "stadeGame": "Stade de Thidé",
    "heureGame": "16:00",
    "idGroupe": 1,
    "home": "FC Houdalaye",
    "away": " FC Sarandogou",
    "homeScore": 0,
    "awayScore": 1,
    "nomGroupe": "A",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 46,
    "idHome": "7",
    "idAway": "9",
    "dateGame": "2023-08-06",
    "stadeGame": "Stade de Thidé",
    "heureGame": "16:00",
    "idGroupe": 3,
    "home": "Fc Doubango",
    "away": "FC Carrafo",
    "homeScore": 2,
    "awayScore": 1,
    "nomGroupe": "C",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 47,
    "idHome": "13",
    "idAway": "14",
    "dateGame": "2023-08-09",
    "stadeGame": "Stade de Thidé",
    "heureGame": "16:00",
    "idGroupe": 5,
    "home": "FC Sayé",
    "away": "FC Lopel",
    "homeScore": 1,
    "awayScore": 3,
    "nomGroupe": "E",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 49,
    "idHome": "10",
    "idAway": "12",
    "dateGame": "2023-08-10",
    "stadeGame": "Stade de Sayé",
    "heureGame": "16:00",
    "idGroupe": 4,
    "home": "FC Thienel",
    "away": "FC Ndiorol",
    "homeScore": 0,
    "awayScore": 0,
    "nomGroupe": "D",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 50,
    "idHome": "4",
    "idAway": "5",
    "dateGame": "2023-08-11",
    "stadeGame": "Stade de Sayé",
    "heureGame": "16:00",
    "idGroupe": 2,
    "home": "FC Thidé",
    "away": "FC Canal+",
    "homeScore": 0,
    "awayScore": 2,
    "nomGroupe": "B",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 51,
    "idHome": "16",
    "idAway": "17",
    "dateGame": "2023-08-12",
    "stadeGame": "Stade de Sayé",
    "heureGame": "16:00",
    "idGroupe": 6,
    "home": "FC Gourel Boubou",
    "away": "FC Aidis",
    "homeScore": 2,
    "awayScore": 3,
    "nomGroupe": "F",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 52,
    "idHome": "19",
    "idAway": "21",
    "dateGame": "2023-08-13",
    "stadeGame": "Stade de Gourel Boubou",
    "heureGame": "16:00",
    "idGroupe": 7,
    "home": "FC Boghé Dow",
    "away": "FC MBagnou",
    "homeScore": 3,
    "awayScore": 0,
    "nomGroupe": "G",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 53,
    "idHome": "22",
    "idAway": "24",
    "dateGame": "2023-08-14",
    "stadeGame": "Stade de Sayé",
    "heureGame": "16:00",
    "idGroupe": 8,
    "home": "FC Bakaw",
    "away": "FC Horé Mondjé",
    "homeScore": 0,
    "awayScore": 1,
    "nomGroupe": "H",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 54,
    "idHome": "2",
    "idAway": "1",
    "dateGame": "2023-08-15",
    "stadeGame": "Stade de Thidé",
    "heureGame": "16:00",
    "idGroupe": 1,
    "home": "FC Douboungué",
    "away": "FC Houdalaye",
    "homeScore": 3,
    "awayScore": 0,
    "nomGroupe": "A",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 55,
    "idHome": "5",
    "idAway": "6",
    "dateGame": "2023-08-16",
    "stadeGame": "Stade de Gourel Boubou",
    "heureGame": "16:00",
    "idGroupe": 2,
    "home": "FC Canal+",
    "away": "FC Nioly3",
    "homeScore": 1,
    "awayScore": 0,
    "nomGroupe": "B",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 56,
    "idHome": "9",
    "idAway": "8",
    "dateGame": "2023-08-18",
    "stadeGame": "Stade de Sayé",
    "heureGame": "16:00",
    "idGroupe": 3,
    "home": "FC Carrafo",
    "away": "FC Boghé Centre",
    "homeScore": 1,
    "awayScore": 2,
    "nomGroupe": "C",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 57,
    "idHome": "12",
    "idAway": "11",
    "dateGame": "2023-08-19",
    "stadeGame": "Stade de Gourel Boubou",
    "heureGame": "16:00",
    "idGroupe": 4,
    "home": "FC Ndiorol",
    "away": "FC Base",
    "homeScore": 0,
    "awayScore": 1,
    "nomGroupe": "D",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 58,
    "idHome": "14",
    "idAway": "15",
    "dateGame": "2023-08-20",
    "stadeGame": "Stade de Thidé",
    "heureGame": "16:00",
    "idGroupe": 5,
    "home": "FC Lopel",
    "away": "FC Inter",
    "homeScore": 2,
    "awayScore": 1,
    "nomGroupe": "E",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 59,
    "idHome": "17",
    "idAway": "18",
    "dateGame": "2023-08-21",
    "stadeGame": "Stade de Sayé",
    "heureGame": "16:00",
    "idGroupe": 6,
    "home": "FC Aidis",
    "away": "FC Central",
    "homeScore": 3,
    "awayScore": 0,
    "nomGroupe": "F",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 60,
    "idHome": "21",
    "idAway": "20",
    "dateGame": "2023-08-25",
    "stadeGame": "Stade de Gourel Boubou",
    "heureGame": "16:00",
    "idGroupe": 7,
    "home": "FC MBagnou",
    "away": "FC Nioly Carrefour",
    "homeScore": 1,
    "awayScore": 1,
    "nomGroupe": "G",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr2",
    "nomNiveau": "tour 2",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 61,
    "idHome": "24",
    "idAway": "23",
    "dateGame": "2023-08-25",
    "stadeGame": "Stade de Thidé",
    "heureGame": "16:00",
    "idGroupe": 8,
    "home": "FC Horé Mondjé",
    "away": "FC Boghé Escale",
    "homeScore": 2,
    "awayScore": 2,
    "nomGroupe": "H",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr2",
    "nomNiveau": "tour 2",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 62,
    "idHome": "3",
    "idAway": "2",
    "dateGame": "2023-08-26",
    "stadeGame": "Stade de Sayé",
    "heureGame": "16:00",
    "idGroupe": 1,
    "home": " FC Sarandogou",
    "away": "FC Douboungué",
    "homeScore": 2,
    "awayScore": 0,
    "nomGroupe": "A",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr2",
    "nomNiveau": "tour 2",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 64,
    "idHome": "6",
    "idAway": "4",
    "dateGame": "2023-08-27",
    "stadeGame": "Stade de Sayé",
    "heureGame": "16:00",
    "idGroupe": 2,
    "home": "FC Nioly3",
    "away": "FC Thidé",
    "homeScore": 0,
    "awayScore": 2,
    "nomGroupe": "B",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr2",
    "nomNiveau": "tour 2",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 65,
    "idHome": "8",
    "idAway": "7",
    "dateGame": "2023-08-29",
    "stadeGame": "Stade de Thidé",
    "heureGame": "16:00",
    "idGroupe": 3,
    "home": "FC Boghé Centre",
    "away": "Fc Doubango",
    "homeScore": 0,
    "awayScore": 3,
    "nomGroupe": "C",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr2",
    "nomNiveau": "tour 2",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 66,
    "idHome": "11",
    "idAway": "10",
    "dateGame": "2023-08-29",
    "stadeGame": "Stade de Gourel Boubou",
    "heureGame": "16:00",
    "idGroupe": 4,
    "home": "FC Base",
    "away": "FC Thienel",
    "homeScore": 0,
    "awayScore": 0,
    "nomGroupe": "D",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr2",
    "nomNiveau": "tour 2",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 68,
    "idHome": "18",
    "idAway": "16",
    "dateGame": "2023-08-31",
    "stadeGame": "Stade de Sayé",
    "heureGame": "16:00",
    "idGroupe": 6,
    "home": "FC Central",
    "away": "FC Gourel Boubou",
    "homeScore": 1,
    "awayScore": 2,
    "nomGroupe": "F",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr2",
    "nomNiveau": "tour 2",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 69,
    "idHome": "20",
    "idAway": "19",
    "dateGame": "2023-09-01",
    "stadeGame": "Stade de Thidé",
    "heureGame": "16:00",
    "idGroupe": 7,
    "home": "FC Nioly Carrefour",
    "away": "FC Boghé Dow",
    "homeScore": 0,
    "awayScore": 1,
    "nomGroupe": "G",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr2",
    "nomNiveau": "tour 2",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 70,
    "idHome": "23",
    "idAway": "22",
    "dateGame": "2023-09-02",
    "stadeGame": "Stade de Thidé",
    "heureGame": "16:00",
    "idGroupe": 8,
    "home": "FC Boghé Escale",
    "away": "FC Bakaw",
    "homeScore": 2,
    "awayScore": 1,
    "nomGroupe": "H",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "grp",
    "codeNiveau": "tr2",
    "nomNiveau": "tour 2",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 73,
    "idHome": "19",
    "idAway": "7",
    "dateGame": "2023-09-07",
    "stadeGame": "Stade de Gourel Boubou",
    "heureGame": "16:00",
    "idGroupe": 11,
    "home": "FC Boghé Dow",
    "away": "Fc Doubango",
    "homeScore": 0,
    "awayScore": 0,
    "nomGroupe": "I",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "qf",
    "codeNiveau": "qf",
    "nomNiveau": "Quart de Final",
    "nomPhase": "Quart de finale",
    "typePhase": "elimination",
    "homeScorePenalty": 4,
    "awayScorePenalty": 6
  },
  {
    "idGame": 74,
    "idHome": "11",
    "idAway": "14",
    "dateGame": "2023-09-08",
    "stadeGame": "Stade de Thidé",
    "heureGame": "16:00",
    "idGroupe": 11,
    "home": "FC Base",
    "away": "FC Lopel",
    "homeScore": 1,
    "awayScore": 0,
    "nomGroupe": "I",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "qf",
    "codeNiveau": "qf",
    "nomNiveau": "Quart de Final",
    "nomPhase": "Quart de finale",
    "typePhase": "elimination",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 75,
    "idHome": "5",
    "idAway": "3",
    "dateGame": "2023-09-09",
    "stadeGame": "Stade de Gourel Boubou",
    "heureGame": "16:00",
    "idGroupe": 11,
    "home": "FC Canal+",
    "away": " FC Sarandogou",
    "homeScore": 1,
    "awayScore": 0,
    "nomGroupe": "I",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "qf",
    "codeNiveau": "qf",
    "nomNiveau": "Quart de Final",
    "nomPhase": "Quart de finale",
    "typePhase": "elimination",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 76,
    "idHome": "23",
    "idAway": "17",
    "dateGame": "2023-09-10",
    "stadeGame": "Stade de Thidé",
    "heureGame": "16:00",
    "idGroupe": 11,
    "home": "FC Boghé Escale",
    "away": "FC Aidis",
    "homeScore": 0,
    "awayScore": 0,
    "nomGroupe": "I",
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "codePhase": "qf",
    "codeNiveau": "qf",
    "nomNiveau": "Quart de Final",
    "nomPhase": "Quart de finale",
    "typePhase": "elimination",
    "homeScorePenalty": null,
    "awayScorePenalty": null
  }
];
