import 'package:fscore/models/joueur.dart';
import 'package:fscore/models/participant.dart';
import 'package:fscore/core/service/local_service.dart';
import 'package:fscore/core/service/remote_service.dart';

class JoueurService {
  static LocalService get service => LocalService('joueur.json');
  static const String collection = 'joueur';

  static List<Joueur> _toJoueurs(List data, List<Participant> participants) {
    return data
        .where((element) => participants
            .any((e) => e.idParticipant == element['idParticipant'].toString()))
        .map((e) => Joueur.fromJson(
            e,
            participants.singleWhere((element) =>
                element.idParticipant == e['idParticipant'].toString())))
        .toList();
  }

  static Future<List<Joueur>?> getLocalData(
      List<Participant> participants) async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null) return _toJoueurs(data, participants);
    }
    return null;
  }

  static Future<List<Joueur>> getData(List<Participant> participants,
      {bool remote = false}) async {
    if (await service.isLoadable() && !remote)
      return await getLocalData(participants) ?? [];
    final List<Joueur> data = await getRemoteData(participants);
    if (data.isEmpty && await service.hasData())
      return await getLocalData(participants) ?? [];
    return data;
  }

  static Future<List<Joueur>> getRemoteData(
      List<Participant> participants) async {
    try {
      final List data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return _toJoueurs(data, participants);
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addJoueur(Joueur joueur) async {
    final bool res = await RemoteService.setData(
        collection, joueur.idJoueur, joueur.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> deleteJoueur(String idJoueur) async {
    final bool res = await RemoteService.deleteData(collection, idJoueur);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> editJoueur(String idJoueur, Joueur joueur) async {
    final bool res =
        await RemoteService.setData(collection, idJoueur, joueur.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}
