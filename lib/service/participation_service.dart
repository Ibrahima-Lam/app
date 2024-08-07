import 'package:app/models/groupe.dart';
import 'package:app/models/participant.dart';
import 'package:app/models/participation.dart';
import 'package:app/service/local_service.dart';
import 'package:app/service/remote_service.dart';

class ParticipationService {
  static LocalService get service => LocalService('participation.json');
  static const String collection = 'participation';
  static List<Participation> _toParticipation(
      List data, List<Participant> participants, List<Groupe> groupes) {
    return data
        .where(
      (element) =>
          participants.any(
              (e) => e.idParticipant == element['idParticipant'].toString()) &&
          groupes.any((e) => e.idGroupe == element['idGroupe'].toString()),
    )
        .map((e) {
      final Participant participant = participants.singleWhere(
          (element) => element.idParticipant == e['idParticipant'].toString());
      final Groupe groupe = groupes.singleWhere(
          (element) => e['idGroupe'].toString() == element.idGroupe);
      return Participation.fromJson(e, participant, groupe);
    }).toList();
  }

  static Future<List<Participation>?> getLocalData(
      List<Participant> participants, List<Groupe> groupes) async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null) return _toParticipation(data, participants, groupes);
    }
    return null;
  }

  static Future<List<Participation>> getData(
      List<Participant> participants, List<Groupe> groupes,
      {bool remote = false}) async {
    if (await service.isLoadable() && !remote)
      return await getLocalData(participants, groupes) ?? [];
    final List<Participation> data = await getRemoteData(participants, groupes);
    if (data.isEmpty && await service.hasData())
      return await getLocalData(participants, groupes) ?? [];
    return data;
  }

  static Future<List<Participation>> getRemoteData(
      List<Participant> participants, List<Groupe> groupes) async {
    try {
      final List data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return _toParticipation(data, participants, groupes);
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addParticipation(Participation partcipation) async {
    final bool res = await RemoteService.setData(
        collection, partcipation.idParticipation, partcipation.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> editParticipation(
      String idParticipation, Participation participation) async {
    final bool res = await RemoteService.editData(
        collection, idParticipation, participation.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> removeParticipation(String idParticipation) async {
    final bool res =
        await RemoteService.deleteData(collection, idParticipation);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}

List<Map<String, dynamic>> participations = [
  {
    "idParticipation": 25,
    "idGroupe": 9,
    "idParticipant": 25,
    "nomGroupe": "A",
    "codePhase": "grp",
    "codeEdition": "thialgou2023",
    "idEquipe": 26,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Yakaaré Django",
    "libelleEquipe": "Yakaaré Django",
    "localiteEquipe": "Thialgou",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 26,
    "idGroupe": 9,
    "idParticipant": 26,
    "nomGroupe": "A",
    "codePhase": "grp",
    "codeEdition": "thialgou2023",
    "idEquipe": 28,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Yakaaré",
    "libelleEquipe": "Yakaaré",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 27,
    "idGroupe": 9,
    "idParticipant": 27,
    "nomGroupe": "A",
    "codePhase": "grp",
    "codeEdition": "thialgou2023",
    "idEquipe": 27,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Hodere Yontaabé",
    "libelleEquipe": "Hodere Yontaabé",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 28,
    "idGroupe": 9,
    "idParticipant": 28,
    "nomGroupe": "A",
    "codePhase": "grp",
    "codeEdition": "thialgou2023",
    "idEquipe": 29,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Hoderé Bamtaaré",
    "libelleEquipe": "Hoderé Bamtaaré",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 29,
    "idGroupe": 9,
    "idParticipant": 29,
    "nomGroupe": "A",
    "codePhase": "grp",
    "codeEdition": "thialgou2023",
    "idEquipe": 30,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Véterans",
    "libelleEquipe": "Véterans",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 30,
    "idGroupe": 10,
    "idParticipant": 30,
    "nomGroupe": "B",
    "codePhase": "grp",
    "codeEdition": "thialgou2023",
    "idEquipe": 31,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Piindi Bamtaaré",
    "libelleEquipe": "Piindi Bamtaaré",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 31,
    "idGroupe": 10,
    "idParticipant": 31,
    "nomGroupe": "B",
    "codePhase": "grp",
    "codeEdition": "thialgou2023",
    "idEquipe": 33,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Lewlewal",
    "libelleEquipe": "Lewlewal",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 32,
    "idGroupe": 10,
    "idParticipant": 32,
    "nomGroupe": "B",
    "codePhase": "grp",
    "codeEdition": "thialgou2023",
    "idEquipe": 32,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Union",
    "libelleEquipe": "Union",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 33,
    "idGroupe": 10,
    "idParticipant": 33,
    "nomGroupe": "B",
    "codePhase": "grp",
    "codeEdition": "thialgou2023",
    "idEquipe": 34,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Foyré Bamtaaré",
    "libelleEquipe": "Foyré Bamtaaré",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 34,
    "idGroupe": 10,
    "idParticipant": 34,
    "nomGroupe": "B",
    "codePhase": "grp",
    "codeEdition": "thialgou2023",
    "idEquipe": 35,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Abou Sem",
    "libelleEquipe": "Abou Sem",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 43,
    "idGroupe": 12,
    "idParticipant": 28,
    "nomGroupe": "C",
    "codePhase": "df",
    "codeEdition": "thialgou2023",
    "idEquipe": 29,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Hoderé Bamtaaré",
    "libelleEquipe": "Hoderé Bamtaaré",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 44,
    "idGroupe": 12,
    "idParticipant": 25,
    "nomGroupe": "C",
    "codePhase": "df",
    "codeEdition": "thialgou2023",
    "idEquipe": 26,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Yakaaré Django",
    "libelleEquipe": "Yakaaré Django",
    "localiteEquipe": "Thialgou",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 45,
    "idGroupe": 12,
    "idParticipant": 30,
    "nomGroupe": "C",
    "codePhase": "df",
    "codeEdition": "thialgou2023",
    "idEquipe": 31,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Piindi Bamtaaré",
    "libelleEquipe": "Piindi Bamtaaré",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 46,
    "idGroupe": 12,
    "idParticipant": 31,
    "nomGroupe": "C",
    "codePhase": "df",
    "codeEdition": "thialgou2023",
    "idEquipe": 33,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Lewlewal",
    "libelleEquipe": "Lewlewal",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 47,
    "idGroupe": 13,
    "idParticipant": 31,
    "nomGroupe": "D",
    "codePhase": "fn",
    "codeEdition": "thialgou2023",
    "idEquipe": 33,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Lewlewal",
    "libelleEquipe": "Lewlewal",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 48,
    "idGroupe": 13,
    "idParticipant": 30,
    "nomGroupe": "D",
    "codePhase": "fn",
    "codeEdition": "thialgou2023",
    "idEquipe": 31,
    "idEdition": "thialgou2023",
    "nomEquipe": "FC Piindi Bamtaaré",
    "libelleEquipe": "Piindi Bamtaaré",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "idParticipation": 1,
    "idGroupe": 1,
    "idParticipant": 1,
    "nomGroupe": "A",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 5,
    "idEdition": "district2023",
    "nomEquipe": "FC Houdalaye",
    "libelleEquipe": "Houdalaye",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 2,
    "idGroupe": 1,
    "idParticipant": 2,
    "nomGroupe": "A",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 6,
    "idEdition": "district2023",
    "nomEquipe": "FC Douboungué",
    "libelleEquipe": "Douboungué",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 3,
    "idGroupe": 1,
    "idParticipant": 3,
    "nomGroupe": "A",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 7,
    "idEdition": "district2023",
    "nomEquipe": " FC Sarandogou",
    "libelleEquipe": "Sarandogou",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 4,
    "idGroupe": 2,
    "idParticipant": 4,
    "nomGroupe": "B",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 3,
    "idEdition": "district2023",
    "nomEquipe": "FC Thidé",
    "libelleEquipe": "Thidé Diery",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 5,
    "idGroupe": 2,
    "idParticipant": 5,
    "nomGroupe": "B",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 8,
    "idEdition": "district2023",
    "nomEquipe": "FC Canal+",
    "libelleEquipe": "Canal plus",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 6,
    "idGroupe": 2,
    "idParticipant": 6,
    "nomGroupe": "B",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 9,
    "idEdition": "district2023",
    "nomEquipe": "FC Nioly3",
    "libelleEquipe": "Nioly3",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 7,
    "idGroupe": 3,
    "idParticipant": 7,
    "nomGroupe": "C",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 2,
    "idEdition": "district2023",
    "nomEquipe": "Fc Doubango",
    "libelleEquipe": "Touldé Doubango",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 8,
    "idGroupe": 3,
    "idParticipant": 8,
    "nomGroupe": "C",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 10,
    "idEdition": "district2023",
    "nomEquipe": "FC Boghé Centre",
    "libelleEquipe": "Bobhé Centre",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 9,
    "idGroupe": 3,
    "idParticipant": 9,
    "nomGroupe": "C",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 11,
    "idEdition": "district2023",
    "nomEquipe": "FC Carrafo",
    "libelleEquipe": "Carrafo",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 10,
    "idGroupe": 4,
    "idParticipant": 10,
    "nomGroupe": "D",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 12,
    "idEdition": "district2023",
    "nomEquipe": "FC Thienel",
    "libelleEquipe": "Thienel",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 11,
    "idGroupe": 4,
    "idParticipant": 11,
    "nomGroupe": "D",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 13,
    "idEdition": "district2023",
    "nomEquipe": "FC Base",
    "libelleEquipe": "Base",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 12,
    "idGroupe": 4,
    "idParticipant": 12,
    "nomGroupe": "D",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 14,
    "idEdition": "district2023",
    "nomEquipe": "FC Ndiorol",
    "libelleEquipe": "Ndiorol",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 13,
    "idGroupe": 5,
    "idParticipant": 13,
    "nomGroupe": "E",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 15,
    "idEdition": "district2023",
    "nomEquipe": "FC Sayé",
    "libelleEquipe": "Sayé",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 14,
    "idGroupe": 5,
    "idParticipant": 14,
    "nomGroupe": "E",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 16,
    "idEdition": "district2023",
    "nomEquipe": "FC Lopel",
    "libelleEquipe": "Lopel",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 15,
    "idGroupe": 5,
    "idParticipant": 15,
    "nomGroupe": "E",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 17,
    "idEdition": "district2023",
    "nomEquipe": "FC Inter",
    "libelleEquipe": "Inter",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 16,
    "idGroupe": 6,
    "idParticipant": 16,
    "nomGroupe": "F",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 18,
    "idEdition": "district2023",
    "nomEquipe": "FC Gourel Boubou",
    "libelleEquipe": "Gourel Boubou",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 17,
    "idGroupe": 6,
    "idParticipant": 17,
    "nomGroupe": "F",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 19,
    "idEdition": "district2023",
    "nomEquipe": "FC Aidis",
    "libelleEquipe": "Aidis",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 18,
    "idGroupe": 6,
    "idParticipant": 18,
    "nomGroupe": "F",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 20,
    "idEdition": "district2023",
    "nomEquipe": "FC Central",
    "libelleEquipe": "Central",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 19,
    "idGroupe": 7,
    "idParticipant": 19,
    "nomGroupe": "G",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 4,
    "idEdition": "district2023",
    "nomEquipe": "FC Boghé Dow",
    "libelleEquipe": "Boghé Dow",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 20,
    "idGroupe": 7,
    "idParticipant": 20,
    "nomGroupe": "G",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 21,
    "idEdition": "district2023",
    "nomEquipe": "FC Nioly Carrefour",
    "libelleEquipe": "Nioly Carrefour",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 21,
    "idGroupe": 7,
    "idParticipant": 21,
    "nomGroupe": "G",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 22,
    "idEdition": "district2023",
    "nomEquipe": "FC MBagnou",
    "libelleEquipe": "MBagnou",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 22,
    "idGroupe": 8,
    "idParticipant": 22,
    "nomGroupe": "H",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 23,
    "idEdition": "district2023",
    "nomEquipe": "FC Bakaw",
    "libelleEquipe": "Bakaw",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 23,
    "idGroupe": 8,
    "idParticipant": 23,
    "nomGroupe": "H",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 24,
    "idEdition": "district2023",
    "nomEquipe": "FC Boghé Escale",
    "libelleEquipe": "Boghé EScale",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 24,
    "idGroupe": 8,
    "idParticipant": 24,
    "nomGroupe": "H",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "idEquipe": 25,
    "idEdition": "district2023",
    "nomEquipe": "FC Horé Mondjé",
    "libelleEquipe": "Horé Mondjé",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 37,
    "idGroupe": 11,
    "idParticipant": 7,
    "nomGroupe": "I",
    "codePhase": "qf",
    "codeEdition": "district2023",
    "idEquipe": 2,
    "idEdition": "district2023",
    "nomEquipe": "Fc Doubango",
    "libelleEquipe": "Touldé Doubango",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 38,
    "idGroupe": 11,
    "idParticipant": 11,
    "nomGroupe": "I",
    "codePhase": "qf",
    "codeEdition": "district2023",
    "idEquipe": 13,
    "idEdition": "district2023",
    "nomEquipe": "FC Base",
    "libelleEquipe": "Base",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 39,
    "idGroupe": 11,
    "idParticipant": 14,
    "nomGroupe": "I",
    "codePhase": "qf",
    "codeEdition": "district2023",
    "idEquipe": 16,
    "idEdition": "district2023",
    "nomEquipe": "FC Lopel",
    "libelleEquipe": "Lopel",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 40,
    "idGroupe": 11,
    "idParticipant": 17,
    "nomGroupe": "I",
    "codePhase": "qf",
    "codeEdition": "district2023",
    "idEquipe": 19,
    "idEdition": "district2023",
    "nomEquipe": "FC Aidis",
    "libelleEquipe": "Aidis",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 41,
    "idGroupe": 11,
    "idParticipant": 19,
    "nomGroupe": "I",
    "codePhase": "qf",
    "codeEdition": "district2023",
    "idEquipe": 4,
    "idEdition": "district2023",
    "nomEquipe": "FC Boghé Dow",
    "libelleEquipe": "Boghé Dow",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 42,
    "idGroupe": 11,
    "idParticipant": 23,
    "nomGroupe": "I",
    "codePhase": "qf",
    "codeEdition": "district2023",
    "idEquipe": 24,
    "idEdition": "district2023",
    "nomEquipe": "FC Boghé Escale",
    "libelleEquipe": "Boghé EScale",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 56,
    "idGroupe": 11,
    "idParticipant": 3,
    "nomGroupe": "I",
    "codePhase": "qf",
    "codeEdition": "district2023",
    "idEquipe": 7,
    "idEdition": "district2023",
    "nomEquipe": " FC Sarandogou",
    "libelleEquipe": "Sarandogou",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "idParticipation": 57,
    "idGroupe": 11,
    "idParticipant": 5,
    "nomGroupe": "I",
    "codePhase": "qf",
    "codeEdition": "district2023",
    "idEquipe": 8,
    "idEdition": "district2023",
    "nomEquipe": "FC Canal+",
    "libelleEquipe": "Canal plus",
    "localiteEquipe": null,
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  }
];
