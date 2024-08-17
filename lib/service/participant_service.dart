import 'package:app/models/participant.dart';
import 'package:app/core/service/local_service.dart';
import 'package:app/core/service/remote_service.dart';

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
