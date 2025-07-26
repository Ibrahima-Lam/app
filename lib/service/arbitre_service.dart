import 'package:fscore/models/arbitres/arbitre.dart';
import 'package:fscore/core/service/local_service.dart';
import 'package:fscore/core/service/remote_service.dart';

class ArbitreService {
  static LocalService get service => LocalService('arbitre.json');
  static const String collection = 'arbitre';

  static Future<List<Arbitre>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null) return data.map((e) => Arbitre.fromJson(e)).toList();
    }
    return null;
  }

  static Future<List<Arbitre>> getData({bool remote = false}) async {
    if (await service.isLoadable() && !remote)
      return await getLocalData() ?? [];
    final List<Arbitre> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Arbitre>> getRemoteData() async {
    try {
      final List data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return data.map((e) => Arbitre.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addArbitre(Arbitre arbitre) async {
    final bool res = await RemoteService.setData(
        collection, arbitre.idArbitre, arbitre.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> editArbitre(String idArbitre, Arbitre arbitre) async {
    final bool res =
        await RemoteService.setData(collection, idArbitre, arbitre.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> deleteArbitre(String idArbitre) async {
    final bool res = await RemoteService.deleteData(collection, idArbitre);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}
