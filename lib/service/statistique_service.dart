import 'package:app/models/statistique.dart';
import 'package:app/core/service/local_service.dart';
import 'package:app/core/service/remote_service.dart';

class StatistiqueService {
  static LocalService get service => LocalService('statistique.json');
  static const String collection = 'statistique';

  static Future<List<Statistique>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null)
        return data.map((e) => Statistique.fromJson(e)).toList();
    }
    return null;
  }

  static Future<List<Statistique>> getData({bool remote = false}) async {
    if (await service.isLoadable(2) && !remote)
      return await getLocalData() ?? [];
    final List<Statistique> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Statistique>> getRemoteData() async {
    try {
      final List data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return data.map((e) => Statistique.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addStatistique(Statistique stat) async {
    final bool res = await RemoteService.setData(
        collection, stat.idStatistique, stat.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> editStatistique(
      String idStatistique, Statistique stat) async {
    final bool res =
        await RemoteService.setData(collection, idStatistique, stat.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> deleteStatistique(String idStatistique) async {
    final bool res = await RemoteService.deleteData(collection, idStatistique);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}
