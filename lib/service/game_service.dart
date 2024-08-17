import 'package:app/models/game.dart';
import 'package:app/models/groupe.dart';
import 'package:app/models/niveau.dart';
import 'package:app/models/participant.dart';
import 'package:app/core/service/local_service.dart';
import 'package:app/service/niveau_service.dart';
import 'package:app/core/service/remote_service.dart';

class GameService {
  static const file = 'game.json';
  static const String collection = 'game';
  static LocalService get service => LocalService(file);
  Future<List<Game>> _toGame(
      List data, List<Participant> participants, List<Groupe> groupes) async {
    List<Niveau> niveaux = await NiveauService.getNiveaux();
    return data
        .where(
      (element) =>
          participants.any((e) => e.idParticipant == element['idHome']) &&
          participants.any((e) => e.idParticipant == element['idAway']) &&
          groupes.any((e) => e.idGroupe == element['idGroupe'].toString()),
    )
        .map((e) {
      Participant home = participants
          .singleWhere((element) => element.idParticipant == e['idHome']);
      Participant away = participants
          .singleWhere((element) => element.idParticipant == e['idAway']);
      Niveau niveau = niveaux.singleWhere(
        (element) => element.codeNiveau == e['codeNiveau'],
        orElse: () => Niveau(
            codeNiveau: '', nomNiveau: '', typeNiveau: '', ordreNiveau: ''),
      );
      Groupe groupe = groupes.singleWhere(
          (element) => e['idGroupe'].toString() == element.idGroupe);
      return Game.fromJson(e,
          home: home, away: away, niveau: niveau, groupe: groupe);
    }).toList()
      ..sort(_sorter);
  }

  int _sorter(Game a, Game b) {
    if ((a.dateGame ?? '').compareTo(b.dateGame ?? '') != 0)
      return (a.dateGame ?? '').compareTo(b.dateGame ?? '');
    return (a.heureGame ?? '').compareTo(b.heureGame ?? '');
  }

  Future<List<Game>?> getLocalData(
    List<Participant> participants,
    List<Groupe> groupes,
  ) async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null) return _toGame(data, participants, groupes);
    }
    return null;
  }

  Future<List<Game>> getData(
      List<Participant> participants, List<Groupe> groupes,
      {bool remote = false}) async {
    if (await service.isLoadable(2) && !remote)
      return await getLocalData(participants, groupes) ?? [];
    final List<Game> data = await getRemoteData(participants, groupes);
    if (data.isEmpty && await service.hasData())
      return await getLocalData(participants, groupes) ?? [];
    return data;
  }

  Future<List<Game>> getRemoteData(
      List<Participant> participants, List<Groupe> groupes) async {
    try {
      final List data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return _toGame(data, participants, groupes);
    } catch (e) {
      return [];
    }
  }

  Future<bool> addGame(Game game) async {
    final bool res =
        await RemoteService.setData(collection, game.idGame, game.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  Future<bool> removeGame(String idGame) async {
    final bool res = await RemoteService.deleteData(collection, idGame);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  Future<bool> editGame(String idGame, Game game) async {
    final bool res =
        await RemoteService.setData(collection, idGame, game.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}
