import 'package:app/models/event.dart';
import 'package:app/service/local_service.dart';
import 'package:app/service/remote_service.dart';

class ButService {
  static LocalService get service => LocalService('but.json');
  static const String collection = 'but';

  static Future<List<GoalEvent>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null) return data.map((e) => GoalEvent.fromJson(e)).toList();
    }
    return null;
  }

  static Future<List<GoalEvent>> getData({bool remote = false}) async {
    final List<GoalEvent> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<GoalEvent>> getRemoteData() async {
    try {
      final List data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return data.map((e) => GoalEvent.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addGoalEvent(GoalEvent event) async {
    final bool res =
        await RemoteService.setData(collection, event.idEvent, event.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> editGoalEvent(String idBut, GoalEvent event) async {
    final bool res =
        await RemoteService.setData(collection, idBut, event.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> deleteGoalEvent(String idBut) async {
    final bool res = await RemoteService.deleteData(collection, idBut);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}

final List<Map<String, dynamic>> buts = [
  {
    "num": null,
    "idJoueur": 5,
    "nomJoueur": "Amadou cheick",
    "team": "FC Yakaaré Django",
    "idTeam": 25,
    "idParticipant": 25,
    "nomEquipe": "FC Yakaaré Django",
    "idGame": 1,
    "homeGame": "25",
    "awayGame": "26",
    "dateGame": "2023-08-06",
    "minute": null,
    "idBut": 1,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 6,
    "nomJoueur": "Amadou Daddé",
    "team": "FC Yakaaré Django",
    "idTeam": 25,
    "idParticipant": 25,
    "nomEquipe": "FC Yakaaré Django",
    "idGame": 1,
    "homeGame": "25",
    "awayGame": "26",
    "dateGame": "2023-08-06",
    "minute": null,
    "idBut": 2,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 10,
    "nomJoueur": "Issa Dia",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 3,
    "homeGame": "30",
    "awayGame": "31",
    "dateGame": "2023-08-08",
    "minute": "",
    "idBut": 5,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 11,
    "nomJoueur": "Athoumani",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 3,
    "homeGame": "30",
    "awayGame": "31",
    "dateGame": "2023-08-08",
    "minute": "",
    "idBut": 6,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 13,
    "nomJoueur": "El-hadji Diallo",
    "team": "FC Hoderé Bamtaaré",
    "idTeam": 28,
    "idParticipant": 28,
    "nomEquipe": "FC Hoderé Bamtaaré",
    "idGame": 4,
    "homeGame": "27",
    "awayGame": "28",
    "dateGame": "2023-08-09",
    "minute": "",
    "idBut": 8,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 27,
    "nomJoueur": "Sada Kelly",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 48,
    "homeGame": "34",
    "awayGame": "30",
    "dateGame": "2023-08-14",
    "minute": "",
    "idBut": 9,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 27,
    "nomJoueur": "Sada Kelly",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 48,
    "homeGame": "34",
    "awayGame": "30",
    "dateGame": "2023-08-14",
    "minute": "",
    "idBut": 10,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 27,
    "nomJoueur": "Sada Kelly",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 48,
    "homeGame": "34",
    "awayGame": "30",
    "dateGame": "2023-08-14",
    "minute": "",
    "idBut": 11,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 28,
    "nomJoueur": "Ibra NGaidé",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 48,
    "homeGame": "34",
    "awayGame": "30",
    "dateGame": "2023-08-14",
    "minute": "",
    "idBut": 12,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 9,
    "nomJoueur": "Baba Ciré",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 48,
    "homeGame": "34",
    "awayGame": "30",
    "dateGame": "2023-08-14",
    "minute": "",
    "idBut": 13,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 29,
    "nomJoueur": "Mocktar Dia",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 48,
    "homeGame": "34",
    "awayGame": "30",
    "dateGame": "2023-08-14",
    "minute": "",
    "idBut": 14,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 31,
    "nomJoueur": "Mika Diallo",
    "team": "FC Abou Sem",
    "idTeam": 34,
    "idParticipant": 34,
    "nomEquipe": "FC Abou Sem",
    "idGame": 48,
    "homeGame": "34",
    "awayGame": "30",
    "dateGame": "2023-08-14",
    "minute": "",
    "idBut": 15,
    "codeEdition": "thialgou2023",
    "codeMarque": "penalty",
    "nomMarque": "But sur penalty",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 32,
    "nomJoueur": "Babo Sy",
    "team": "FC Foyré Bamtaaré",
    "idTeam": 33,
    "idParticipant": 33,
    "nomEquipe": "FC Foyré Bamtaaré",
    "idGame": 32,
    "homeGame": "32",
    "awayGame": "33",
    "dateGame": "2023-08-10",
    "minute": "",
    "idBut": 16,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 33,
    "nomJoueur": "Harouna",
    "team": "FC Foyré Bamtaaré",
    "idTeam": 33,
    "idParticipant": 33,
    "nomEquipe": "FC Foyré Bamtaaré",
    "idGame": 32,
    "homeGame": "32",
    "awayGame": "33",
    "dateGame": "2023-08-10",
    "minute": "",
    "idBut": 18,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 34,
    "nomJoueur": "Ablaye Talll",
    "team": "FC Foyré Bamtaaré",
    "idTeam": 33,
    "idParticipant": 33,
    "nomEquipe": "FC Foyré Bamtaaré",
    "idGame": 32,
    "homeGame": "32",
    "awayGame": "33",
    "dateGame": "2023-08-10",
    "minute": "",
    "idBut": 19,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 35,
    "nomJoueur": "Abou Dia",
    "team": "FC Yakaaré Django",
    "idTeam": 25,
    "idParticipant": 25,
    "nomEquipe": "FC Yakaaré Django",
    "idGame": 33,
    "homeGame": "29",
    "awayGame": "25",
    "dateGame": "2023-08-15",
    "minute": "",
    "idBut": 20,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 36,
    "nomJoueur": "Mama Dia",
    "team": "FC Yakaaré Django",
    "idTeam": 25,
    "idParticipant": 25,
    "nomEquipe": "FC Yakaaré Django",
    "idGame": 33,
    "homeGame": "29",
    "awayGame": "25",
    "dateGame": "2023-08-15",
    "minute": "",
    "idBut": 21,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 38,
    "nomJoueur": "Hamodou",
    "team": "FC Yakaaré Django",
    "idTeam": 25,
    "idParticipant": 25,
    "nomEquipe": "FC Yakaaré Django",
    "idGame": 33,
    "homeGame": "29",
    "awayGame": "25",
    "dateGame": "2023-08-15",
    "minute": "",
    "idBut": 22,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 5,
    "nomJoueur": "Amadou cheick",
    "team": "FC Yakaaré Django",
    "idTeam": 25,
    "idParticipant": 25,
    "nomEquipe": "FC Yakaaré Django",
    "idGame": 33,
    "homeGame": "29",
    "awayGame": "25",
    "dateGame": "2023-08-15",
    "minute": "",
    "idBut": 23,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 5,
    "nomJoueur": "Amadou cheick",
    "team": "FC Yakaaré Django",
    "idTeam": 25,
    "idParticipant": 25,
    "nomEquipe": "FC Yakaaré Django",
    "idGame": 33,
    "homeGame": "29",
    "awayGame": "25",
    "dateGame": "2023-08-15",
    "minute": "",
    "idBut": 24,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 6,
    "nomJoueur": "Amadou Daddé",
    "team": "FC Yakaaré Django",
    "idTeam": 25,
    "idParticipant": 25,
    "nomEquipe": "FC Yakaaré Django",
    "idGame": 33,
    "homeGame": "29",
    "awayGame": "25",
    "dateGame": "2023-08-15",
    "minute": "",
    "idBut": 25,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 37,
    "nomJoueur": "Thierno Lamine",
    "team": "FC Yakaaré Django",
    "idTeam": 25,
    "idParticipant": 25,
    "nomEquipe": "FC Yakaaré Django",
    "idGame": 33,
    "homeGame": "29",
    "awayGame": "25",
    "dateGame": "2023-08-15",
    "minute": "",
    "idBut": 26,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 41,
    "nomJoueur": "Hamodou Syel",
    "team": "FC Hodere Yontaabé",
    "idTeam": 27,
    "idParticipant": 27,
    "nomEquipe": "FC Hodere Yontaabé",
    "idGame": 34,
    "homeGame": "27",
    "awayGame": "26",
    "dateGame": "2023-08-16",
    "minute": "",
    "idBut": 27,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 41,
    "nomJoueur": "Hamodou Syel",
    "team": "FC Hodere Yontaabé",
    "idTeam": 27,
    "idParticipant": 27,
    "nomEquipe": "FC Hodere Yontaabé",
    "idGame": 34,
    "homeGame": "27",
    "awayGame": "26",
    "dateGame": "2023-08-16",
    "minute": "",
    "idBut": 28,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 42,
    "nomJoueur": "Abdoul",
    "team": "FC Hodere Yontaabé",
    "idTeam": 27,
    "idParticipant": 27,
    "nomEquipe": "FC Hodere Yontaabé",
    "idGame": 34,
    "homeGame": "27",
    "awayGame": "26",
    "dateGame": "2023-08-16",
    "minute": "",
    "idBut": 29,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 43,
    "nomJoueur": "Adama Lam",
    "team": "FC Hodere Yontaabé",
    "idTeam": 27,
    "idParticipant": 27,
    "nomEquipe": "FC Hodere Yontaabé",
    "idGame": 34,
    "homeGame": "27",
    "awayGame": "26",
    "dateGame": "2023-08-16",
    "minute": "",
    "idBut": 30,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 48,
    "nomJoueur": "Amadou Dia",
    "team": "FC Lewlewal",
    "idTeam": 31,
    "idParticipant": 31,
    "nomEquipe": "FC Lewlewal",
    "idGame": 43,
    "homeGame": "31",
    "awayGame": "32",
    "dateGame": "2023-08-17",
    "minute": "",
    "idBut": 31,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 12,
    "nomJoueur": "Alsane Bellel",
    "team": "FC Lewlewal",
    "idTeam": 31,
    "idParticipant": 31,
    "nomEquipe": "FC Lewlewal",
    "idGame": 43,
    "homeGame": "31",
    "awayGame": "32",
    "dateGame": "2023-08-17",
    "minute": "",
    "idBut": 32,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 49,
    "nomJoueur": "Tidjani Diou",
    "team": "FC Lewlewal",
    "idTeam": 31,
    "idParticipant": 31,
    "nomEquipe": "FC Lewlewal",
    "idGame": 43,
    "homeGame": "31",
    "awayGame": "32",
    "dateGame": "2023-08-17",
    "minute": "",
    "idBut": 33,
    "codeEdition": "thialgou2023",
    "codeMarque": "penalty",
    "nomMarque": "But sur penalty",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 52,
    "nomJoueur": "Youssouf Dia",
    "team": "FC Union",
    "idTeam": 32,
    "idParticipant": 32,
    "nomEquipe": "FC Union",
    "idGame": 43,
    "homeGame": "31",
    "awayGame": "32",
    "dateGame": "2023-08-17",
    "minute": "",
    "idBut": 34,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 13,
    "nomJoueur": "El-hadji Diallo",
    "team": "FC Hoderé Bamtaaré",
    "idTeam": 28,
    "idParticipant": 28,
    "nomEquipe": "FC Hoderé Bamtaaré",
    "idGame": 36,
    "homeGame": "28",
    "awayGame": "29",
    "dateGame": "2023-08-18",
    "minute": "",
    "idBut": 35,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 13,
    "nomJoueur": "El-hadji Diallo",
    "team": "FC Hoderé Bamtaaré",
    "idTeam": 28,
    "idParticipant": 28,
    "nomEquipe": "FC Hoderé Bamtaaré",
    "idGame": 36,
    "homeGame": "28",
    "awayGame": "29",
    "dateGame": "2023-08-18",
    "minute": "",
    "idBut": 36,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 13,
    "nomJoueur": "El-hadji Diallo",
    "team": "FC Hoderé Bamtaaré",
    "idTeam": 28,
    "idParticipant": 28,
    "nomEquipe": "FC Hoderé Bamtaaré",
    "idGame": 36,
    "homeGame": "28",
    "awayGame": "29",
    "dateGame": "2023-08-18",
    "minute": "",
    "idBut": 37,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 58,
    "nomJoueur": "Ablaye Dédé",
    "team": "FC Véterans",
    "idTeam": 29,
    "idParticipant": 29,
    "nomEquipe": "FC Véterans",
    "idGame": 36,
    "homeGame": "28",
    "awayGame": "29",
    "dateGame": "2023-08-18",
    "minute": "",
    "idBut": 38,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 59,
    "nomJoueur": "Aguibe Lam",
    "team": "FC Véterans",
    "idTeam": 29,
    "idParticipant": 29,
    "nomEquipe": "FC Véterans",
    "idGame": 36,
    "homeGame": "28",
    "awayGame": "29",
    "dateGame": "2023-08-18",
    "minute": "",
    "idBut": 39,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 33,
    "nomJoueur": "Harouna",
    "team": "FC Foyré Bamtaaré",
    "idTeam": 33,
    "idParticipant": 33,
    "nomEquipe": "FC Foyré Bamtaaré",
    "idGame": 71,
    "homeGame": "33",
    "awayGame": "34",
    "dateGame": "2023-08-19",
    "minute": "",
    "idBut": 40,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 24,
    "nomJoueur": "Bra NGaidé",
    "team": "FC Foyré Bamtaaré",
    "idTeam": 33,
    "idParticipant": 33,
    "nomEquipe": "FC Foyré Bamtaaré",
    "idGame": 71,
    "homeGame": "33",
    "awayGame": "34",
    "dateGame": "2023-08-19",
    "minute": "",
    "idBut": 41,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 31,
    "nomJoueur": "Mika Diallo",
    "team": "FC Abou Sem",
    "idTeam": 34,
    "idParticipant": 34,
    "nomEquipe": "FC Abou Sem",
    "idGame": 71,
    "homeGame": "33",
    "awayGame": "34",
    "dateGame": "2023-08-19",
    "minute": "",
    "idBut": 42,
    "codeEdition": "thialgou2023",
    "codeMarque": "penalty",
    "nomMarque": "But sur penalty",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 63,
    "nomJoueur": "Alsane NGaidé",
    "team": "FC Abou Sem",
    "idTeam": 34,
    "idParticipant": 33,
    "nomEquipe": "FC Foyré Bamtaaré",
    "idGame": 71,
    "homeGame": "33",
    "awayGame": "34",
    "dateGame": "2023-08-19",
    "minute": "",
    "idBut": 43,
    "codeEdition": "thialgou2023",
    "codeMarque": "butcontre",
    "nomMarque": "But Contre son Camp",
    "typeMarque": "contre"
  },
  {
    "num": null,
    "idJoueur": 64,
    "nomJoueur": "Hamet Lam",
    "team": "FC Foyré Bamtaaré",
    "idTeam": 33,
    "idParticipant": 33,
    "nomEquipe": "FC Foyré Bamtaaré",
    "idGame": 71,
    "homeGame": "33",
    "awayGame": "34",
    "dateGame": "2023-08-19",
    "minute": "",
    "idBut": 44,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 6,
    "nomJoueur": "Amadou Daddé",
    "team": "FC Yakaaré Django",
    "idTeam": 25,
    "idParticipant": 25,
    "nomEquipe": "FC Yakaaré Django",
    "idGame": 37,
    "homeGame": "25",
    "awayGame": "27",
    "dateGame": "2023-08-23",
    "minute": "",
    "idBut": 45,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 13,
    "nomJoueur": "El-hadji Diallo",
    "team": "FC Hoderé Bamtaaré",
    "idTeam": 28,
    "idParticipant": 28,
    "nomEquipe": "FC Hoderé Bamtaaré",
    "idGame": 39,
    "homeGame": "26",
    "awayGame": "28",
    "dateGame": "2023-08-25",
    "minute": "",
    "idBut": 46,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 71,
    "nomJoueur": "Seydi Ly",
    "team": "FC Hoderé Bamtaaré",
    "idTeam": 28,
    "idParticipant": 28,
    "nomEquipe": "FC Hoderé Bamtaaré",
    "idGame": 39,
    "homeGame": "26",
    "awayGame": "28",
    "dateGame": "2023-08-25",
    "minute": "",
    "idBut": 47,
    "codeEdition": "thialgou2023",
    "codeMarque": "penalty",
    "nomMarque": "But sur penalty",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 70,
    "nomJoueur": "Ablaye Mattel",
    "team": "FC Hoderé Bamtaaré",
    "idTeam": 28,
    "idParticipant": 28,
    "nomEquipe": "FC Hoderé Bamtaaré",
    "idGame": 39,
    "homeGame": "26",
    "awayGame": "28",
    "dateGame": "2023-08-25",
    "minute": "",
    "idBut": 48,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 80,
    "nomJoueur": "Ciré Sy",
    "team": "FC Union",
    "idTeam": 32,
    "idParticipant": 32,
    "nomEquipe": "FC Union",
    "idGame": 72,
    "homeGame": "34",
    "awayGame": "32",
    "dateGame": "2023-08-29",
    "minute": "",
    "idBut": 49,
    "codeEdition": "thialgou2023",
    "codeMarque": "penalty",
    "nomMarque": "But sur penalty",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 84,
    "nomJoueur": "Adama Lam",
    "team": "FC Véterans",
    "idTeam": 29,
    "idParticipant": 29,
    "nomEquipe": "FC Véterans",
    "idGame": 40,
    "homeGame": "29",
    "awayGame": "27",
    "dateGame": "2023-09-03",
    "minute": "",
    "idBut": 50,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 84,
    "nomJoueur": "Adama Lam",
    "team": "FC Véterans",
    "idTeam": 29,
    "idParticipant": 29,
    "nomEquipe": "FC Véterans",
    "idGame": 40,
    "homeGame": "29",
    "awayGame": "27",
    "dateGame": "2023-09-03",
    "minute": "",
    "idBut": 51,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 84,
    "nomJoueur": "Adama Lam",
    "team": "FC Véterans",
    "idTeam": 29,
    "idParticipant": 29,
    "nomEquipe": "FC Véterans",
    "idGame": 40,
    "homeGame": "29",
    "awayGame": "27",
    "dateGame": "2023-09-03",
    "minute": "",
    "idBut": 52,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 39,
    "nomJoueur": "Oumar Moussa",
    "team": "FC Véterans",
    "idTeam": 29,
    "idParticipant": 29,
    "nomEquipe": "FC Véterans",
    "idGame": 40,
    "homeGame": "29",
    "awayGame": "27",
    "dateGame": "2023-09-03",
    "minute": "",
    "idBut": 53,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 84,
    "nomJoueur": "Adama Lam",
    "team": "FC Véterans",
    "idTeam": 29,
    "idParticipant": 29,
    "nomEquipe": "FC Véterans",
    "idGame": 40,
    "homeGame": "29",
    "awayGame": "27",
    "dateGame": "2023-09-03",
    "minute": "",
    "idBut": 54,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 39,
    "nomJoueur": "Oumar Moussa",
    "team": "FC Véterans",
    "idTeam": 29,
    "idParticipant": 29,
    "nomEquipe": "FC Véterans",
    "idGame": 40,
    "homeGame": "29",
    "awayGame": "27",
    "dateGame": "2023-09-03",
    "minute": "",
    "idBut": 55,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 43,
    "nomJoueur": "Adama Lam",
    "team": "FC Hodere Yontaabé",
    "idTeam": 27,
    "idParticipant": 27,
    "nomEquipe": "FC Hodere Yontaabé",
    "idGame": 40,
    "homeGame": "29",
    "awayGame": "27",
    "dateGame": "2023-09-03",
    "minute": "",
    "idBut": 56,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 25,
    "nomJoueur": "Lass Sy",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 35,
    "homeGame": "30",
    "awayGame": "32",
    "dateGame": "2023-09-06",
    "minute": "",
    "idBut": 57,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 29,
    "nomJoueur": "Mocktar Dia",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 35,
    "homeGame": "30",
    "awayGame": "32",
    "dateGame": "2023-09-06",
    "minute": "",
    "idBut": 58,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 21,
    "nomJoueur": "Ablaye Thillo",
    "team": "FC Union",
    "idTeam": 32,
    "idParticipant": 32,
    "nomEquipe": "FC Union",
    "idGame": 35,
    "homeGame": "30",
    "awayGame": "32",
    "dateGame": "2023-09-06",
    "minute": "",
    "idBut": 59,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 86,
    "nomJoueur": "Momo Lam",
    "team": "FC Union",
    "idTeam": 32,
    "idParticipant": 32,
    "nomEquipe": "FC Union",
    "idGame": 35,
    "homeGame": "30",
    "awayGame": "32",
    "dateGame": "2023-09-06",
    "minute": "",
    "idBut": 60,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 13,
    "nomJoueur": "El-hadji Diallo",
    "team": "FC Hoderé Bamtaaré",
    "idTeam": 28,
    "idParticipant": 28,
    "nomEquipe": "FC Hoderé Bamtaaré",
    "idGame": 42,
    "homeGame": "25",
    "awayGame": "28",
    "dateGame": "2023-09-14",
    "minute": "",
    "idBut": 61,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 88,
    "nomJoueur": "El-hadji Bathié",
    "team": "FC Hoderé Bamtaaré",
    "idTeam": 28,
    "idParticipant": 28,
    "nomEquipe": "FC Hoderé Bamtaaré",
    "idGame": 42,
    "homeGame": "25",
    "awayGame": "28",
    "dateGame": "2023-09-14",
    "minute": "",
    "idBut": 62,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 37,
    "nomJoueur": "Thierno Lamine",
    "team": "FC Yakaaré Django",
    "idTeam": 25,
    "idParticipant": 25,
    "nomEquipe": "FC Yakaaré Django",
    "idGame": 42,
    "homeGame": "25",
    "awayGame": "28",
    "dateGame": "2023-09-14",
    "minute": "",
    "idBut": 63,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 27,
    "nomJoueur": "Sada Kelly",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 41,
    "homeGame": "33",
    "awayGame": "30",
    "dateGame": "2023-09-13",
    "minute": "",
    "idBut": 64,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 27,
    "nomJoueur": "Sada Kelly",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 41,
    "homeGame": "33",
    "awayGame": "30",
    "dateGame": "2023-09-13",
    "minute": "",
    "idBut": 65,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 11,
    "nomJoueur": "Athoumani",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 41,
    "homeGame": "33",
    "awayGame": "30",
    "dateGame": "2023-09-13",
    "minute": "",
    "idBut": 66,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 10,
    "nomJoueur": "Issa Dia",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 41,
    "homeGame": "33",
    "awayGame": "30",
    "dateGame": "2023-09-13",
    "minute": "",
    "idBut": 68,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 90,
    "nomJoueur": "Oumar Kelly",
    "team": "FC Foyré Bamtaaré",
    "idTeam": 33,
    "idParticipant": 33,
    "nomEquipe": "FC Foyré Bamtaaré",
    "idGame": 41,
    "homeGame": "33",
    "awayGame": "30",
    "dateGame": "2023-09-13",
    "minute": "",
    "idBut": 69,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 12,
    "nomJoueur": "Alsane Bellel",
    "team": "FC Lewlewal",
    "idTeam": 31,
    "idParticipant": 31,
    "nomEquipe": "FC Lewlewal",
    "idGame": 77,
    "homeGame": "34",
    "awayGame": "31",
    "dateGame": "2023-09-15",
    "minute": 50,
    "idBut": 70,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 92,
    "nomJoueur": "Demba Gacko",
    "team": "FC Lewlewal",
    "idTeam": 31,
    "idParticipant": 31,
    "nomEquipe": "FC Lewlewal",
    "idGame": 77,
    "homeGame": "34",
    "awayGame": "31",
    "dateGame": "2023-09-15",
    "minute": 20,
    "idBut": 71,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 73,
    "nomJoueur": "Oumar Amadou",
    "team": "FC Yakaaré",
    "idTeam": 26,
    "idParticipant": 26,
    "nomEquipe": "FC Yakaaré",
    "idGame": 44,
    "homeGame": "26",
    "awayGame": "29",
    "dateGame": "2023-09-18",
    "minute": "",
    "idBut": 72,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 73,
    "nomJoueur": "Oumar Amadou",
    "team": "FC Yakaaré",
    "idTeam": 26,
    "idParticipant": 26,
    "nomEquipe": "FC Yakaaré",
    "idGame": 44,
    "homeGame": "26",
    "awayGame": "29",
    "dateGame": "2023-09-18",
    "minute": "",
    "idBut": 73,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 39,
    "nomJoueur": "Oumar Moussa",
    "team": "FC Véterans",
    "idTeam": 29,
    "idParticipant": 29,
    "nomEquipe": "FC Véterans",
    "idGame": 44,
    "homeGame": "26",
    "awayGame": "29",
    "dateGame": "2023-09-18",
    "minute": "",
    "idBut": 74,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 94,
    "nomJoueur": "Ablaye Diallo",
    "team": "FC Yakaaré",
    "idTeam": 26,
    "idParticipant": 29,
    "nomEquipe": "FC Véterans",
    "idGame": 44,
    "homeGame": "26",
    "awayGame": "29",
    "dateGame": "2023-09-18",
    "minute": "",
    "idBut": 75,
    "codeEdition": "thialgou2023",
    "codeMarque": "butcontre",
    "nomMarque": "But Contre son Camp",
    "typeMarque": "contre"
  },
  {
    "num": null,
    "idJoueur": 13,
    "nomJoueur": "El-hadji Diallo",
    "team": "FC Hoderé Bamtaaré",
    "idTeam": 28,
    "idParticipant": 28,
    "nomEquipe": "FC Hoderé Bamtaaré",
    "idGame": 78,
    "homeGame": "28",
    "awayGame": "31",
    "dateGame": "2023-09-19",
    "minute": "",
    "idBut": 76,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 10,
    "nomJoueur": "Issa Dia",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 79,
    "homeGame": "30",
    "awayGame": "25",
    "dateGame": "2023-09-20",
    "minute": "",
    "idBut": 78,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 10,
    "nomJoueur": "Issa Dia",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 79,
    "homeGame": "30",
    "awayGame": "25",
    "dateGame": "2023-09-20",
    "minute": "",
    "idBut": 79,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 27,
    "nomJoueur": "Sada Kelly",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 80,
    "homeGame": "31",
    "awayGame": "30",
    "dateGame": "2023-09-26",
    "minute": "",
    "idBut": 80,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 10,
    "nomJoueur": "Issa Dia",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 80,
    "homeGame": "31",
    "awayGame": "30",
    "dateGame": "2023-09-26",
    "minute": "",
    "idBut": 81,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  },
  {
    "num": null,
    "idJoueur": 10,
    "nomJoueur": "Issa Dia",
    "team": "FC Piindi Bamtaaré",
    "idTeam": 30,
    "idParticipant": 30,
    "nomEquipe": "FC Piindi Bamtaaré",
    "idGame": 80,
    "homeGame": "31",
    "awayGame": "30",
    "dateGame": "2023-09-26",
    "minute": "",
    "idBut": 82,
    "codeEdition": "thialgou2023",
    "codeMarque": "but",
    "nomMarque": "But",
    "typeMarque": "propre"
  }
];
