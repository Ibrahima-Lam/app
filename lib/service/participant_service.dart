import 'package:app/models/participant.dart';
import 'package:app/service/local_service.dart';
import 'package:app/service/remote_service.dart';

class ParticipantService {
  static LocalService get service => LocalService('participant.json');
  static const String collection = 'participant';

  static int _sorter(Participant a, Participant b) =>
      ((b.rating ?? 0) - (a.rating ?? 0)).toInt();

  static Future<List<Participant>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null)
        return data.map((e) => Participant.fromJson(e)).toList()..sort(_sorter);
    }
    return null;
  }

  static Future<List<Participant>> getData({bool remote = false}) async {
    if (await service.isLoadable() && !remote)
      return await getLocalData() ?? [];
    final List<Participant> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Participant>> getRemoteData() async {
    try {
      final List data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return data.map((e) => Participant.fromJson(e)).toList()..sort(_sorter);
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addParticipant(Participant participant) async {
    final bool res = await RemoteService.setData(
        collection, participant.idParticipant, participant.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> editParticipant(
      String idParticipant, Participant participant) async {
    final bool res = await RemoteService.setData(
        collection, idParticipant, participant.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> removeParticipant(String idParticipant) async {
    final bool res = await RemoteService.deleteData(collection, idParticipant);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}

List<Map<String, dynamic>> participants = [
  {
    "idParticipant": 25,
    "idEquipe": 26,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Yakaaré Django",
    "libelleEquipe": "Yakaaré Django",
    "localiteEquipe": "Thialgou",
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipant": 27,
    "idEquipe": 27,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Hodere Yontaabé",
    "libelleEquipe": "Hodere Yontaabé",
    "localiteEquipe": null,
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipant": 26,
    "idEquipe": 28,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Yakaaré",
    "libelleEquipe": "Yakaaré",
    "localiteEquipe": null,
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipant": 28,
    "idEquipe": 29,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Hoderé Bamtaaré",
    "libelleEquipe": "Hoderé Bamtaaré",
    "localiteEquipe": null,
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipant": 29,
    "idEquipe": 30,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Véterans",
    "libelleEquipe": "Véterans",
    "localiteEquipe": null,
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipant": 30,
    "idEquipe": 31,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Piindi Bamtaaré",
    "libelleEquipe": "Piindi Bamtaaré",
    "localiteEquipe": null,
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipant": 32,
    "idEquipe": 32,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Union",
    "libelleEquipe": "Union",
    "localiteEquipe": null,
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipant": 31,
    "idEquipe": 33,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Lewlewal",
    "libelleEquipe": "Lewlewal",
    "localiteEquipe": null,
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipant": 33,
    "idEquipe": 34,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Foyré Bamtaaré",
    "libelleEquipe": "Foyré Bamtaaré",
    "localiteEquipe": null,
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipant": 34,
    "idEquipe": 35,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Abou Sem",
    "libelleEquipe": "Abou Sem",
    "localiteEquipe": null,
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipant": 7,
    "idEquipe": 2,
    "idEdition": "district2023",
    "nomEquipe": "Fc Doubango",
    "libelleEquipe": "Touldé Doubango",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 4,
    "idEquipe": 3,
    "idEdition": "district2023",
    "nomEquipe": "FC Thidé",
    "libelleEquipe": "Thidé Diery",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 19,
    "idEquipe": 4,
    "idEdition": "district2023",
    "nomEquipe": "FC Boghé Dow",
    "libelleEquipe": "Boghé Dow",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 1,
    "idEquipe": 5,
    "idEdition": "district2023",
    "nomEquipe": "FC Houdalaye",
    "libelleEquipe": "Houdalaye",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 2,
    "idEquipe": 6,
    "idEdition": "district2023",
    "nomEquipe": "FC Douboungué",
    "libelleEquipe": "Douboungué",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 3,
    "idEquipe": 7,
    "idEdition": "district2023",
    "nomEquipe": "FC Sarandogou",
    "libelleEquipe": "Sarandogou",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 5,
    "idEquipe": 8,
    "idEdition": "district2023",
    "nomEquipe": "FC Canal+",
    "libelleEquipe": "Canal plus",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 6,
    "idEquipe": 9,
    "idEdition": "district2023",
    "nomEquipe": "FC Nioly3",
    "libelleEquipe": "Nioly3",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 8,
    "idEquipe": 10,
    "idEdition": "district2023",
    "nomEquipe": "FC Boghé Centre",
    "libelleEquipe": "Bobhé Centre",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 9,
    "idEquipe": 11,
    "idEdition": "district2023",
    "nomEquipe": "FC Carrafo",
    "libelleEquipe": "Carrafo",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 10,
    "idEquipe": 12,
    "idEdition": "district2023",
    "nomEquipe": "FC Thienel",
    "libelleEquipe": "Thienel",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 11,
    "idEquipe": 13,
    "idEdition": "district2023",
    "nomEquipe": "FC Base",
    "libelleEquipe": "Base",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 12,
    "idEquipe": 14,
    "idEdition": "district2023",
    "nomEquipe": "FC Ndiorol",
    "libelleEquipe": "Ndiorol",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 13,
    "idEquipe": 15,
    "idEdition": "district2023",
    "nomEquipe": "FC Sayé",
    "libelleEquipe": "Sayé",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 14,
    "idEquipe": 16,
    "idEdition": "district2023",
    "nomEquipe": "FC Lopel",
    "libelleEquipe": "Lopel",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 15,
    "idEquipe": 17,
    "idEdition": "district2023",
    "nomEquipe": "FC Inter",
    "libelleEquipe": "Inter",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 16,
    "idEquipe": 18,
    "idEdition": "district2023",
    "nomEquipe": "FC Gourel Boubou",
    "libelleEquipe": "Gourel Boubou",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 17,
    "idEquipe": 19,
    "idEdition": "district2023",
    "nomEquipe": "FC Aidis",
    "libelleEquipe": "Aidis",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 18,
    "idEquipe": 20,
    "idEdition": "district2023",
    "nomEquipe": "FC Central",
    "libelleEquipe": "Central",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 20,
    "idEquipe": 21,
    "idEdition": "district2023",
    "nomEquipe": "FC Nioly Carrefour",
    "libelleEquipe": "Nioly Carrefour",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 21,
    "idEquipe": 22,
    "idEdition": "district2023",
    "nomEquipe": "FC MBagnou",
    "libelleEquipe": "MBagnou",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 22,
    "idEquipe": 23,
    "idEdition": "district2023",
    "nomEquipe": "FC Bakaw",
    "libelleEquipe": "Bakaw",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 23,
    "idEquipe": 24,
    "idEdition": "district2023",
    "nomEquipe": "FC Boghé Escale",
    "libelleEquipe": "Boghé EScale",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipant": 24,
    "idEquipe": 25,
    "idEdition": "district2023",
    "nomEquipe": "FC Horé Mondjé",
    "libelleEquipe": "Horé Mondjé",
    "localiteEquipe": null,
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  }
];
