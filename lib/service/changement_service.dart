import 'package:app/models/event.dart';
import 'package:app/core/service/local_service.dart';
import 'package:app/core/service/remote_service.dart';

class ChangementService {
  static LocalService get service => LocalService('changement.json');
  static const String collection = 'changement';

  static Future<List<RemplEvent>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null) return data.map((e) => RemplEvent.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<RemplEvent>> getData({bool remote = false}) async {
    final List<RemplEvent> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<RemplEvent>> getRemoteData() async {
    try {
      final List data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return data.map((e) => RemplEvent.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addRemplEvent(RemplEvent event) async {
    final bool res =
        await RemoteService.setData(collection, event.idEvent, event.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> editRemplEvent(
      String idChangement, RemplEvent event) async {
    final bool res =
        await RemoteService.setData(collection, idChangement, event.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> deleteRemplEvent(String idChangement) async {
    final bool res = await RemoteService.deleteData(collection, idChangement);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}

List<Map<String, dynamic>> changements = [];
