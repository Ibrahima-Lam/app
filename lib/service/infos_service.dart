import 'package:app/models/infos/infos.dart';
import 'package:app/service/local_service.dart';
import 'package:app/service/remote_service.dart';

class InfosService {
  static LocalService get service => LocalService('infos.json');
  static const String collection = 'infos';

  static int _sorter(Infos a, Infos b) =>
      (b.datetime.compareTo(a.datetime)).toInt();

  static Future<List<Infos>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null)
        return data.map((e) => Infos.fromJson(e)).toList()..sort(_sorter);
    }
    return null;
  }

  static Future<List<Infos>> getData({bool remote = false}) async {
    final List<Infos> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Infos>> getRemoteData() async {
    try {
      final List data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return data.map((e) => Infos.fromJson(e)).toList()..sort(_sorter);
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addInfos(Infos info) async {
    final bool res =
        await RemoteService.setData(collection, info.idInfos, info.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> editInfos(String idInfos, Infos info) async {
    final bool res =
        await RemoteService.setData(collection, idInfos, info.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> deleteInfos(String idInfos) async {
    final bool res = await RemoteService.deleteData(collection, idInfos);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}
