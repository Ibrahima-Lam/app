import 'package:app/models/coachs/coach.dart';
import 'package:app/core/service/local_service.dart';
import 'package:app/core/service/remote_service.dart';

class CoachService {
  static LocalService get service => LocalService('coach.json');
  static const String collection = 'coach';

  static Future<List<Coach>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null) return data.map((e) => Coach.fromJson(e)).toList();
    }
    return null;
  }

  static Future<List<Coach>> getData({bool remote = false}) async {
    if (await service.isLoadable() && !remote)
      return await getLocalData() ?? [];
    final List<Coach> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Coach>> getRemoteData() async {
    try {
      final List data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return data.map((e) => Coach.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addCoach(Coach coach) async {
    final bool res =
        await RemoteService.setData(collection, coach.idCoach, coach.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> editCoach(String idCoach, Coach coach) async {
    final bool res =
        await RemoteService.setData(collection, idCoach, coach.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> deleteCoach(String idCoach) async {
    final bool res = await RemoteService.deleteData(collection, idCoach);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}
