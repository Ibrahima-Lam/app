import 'package:fscore/models/event.dart';
import 'package:fscore/core/service/local_service.dart';
import 'package:fscore/core/service/remote_service.dart';

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
