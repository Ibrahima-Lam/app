import 'package:fscore/models/groupe.dart';
import 'package:fscore/models/participant.dart';
import 'package:fscore/models/participation.dart';
import 'package:fscore/core/service/local_service.dart';
import 'package:fscore/core/service/remote_service.dart';

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
