import 'package:app/models/paramettre.dart';
import 'package:app/core/service/local_service.dart';
import 'package:app/core/service/remote_service.dart';

class ParamettreService {
  static LocalService get service => LocalService('paramettrages.json');
  static String collection = 'competitionparamettre';

  static Future<List<Paramettre>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());

      if (data != null) return data.map((e) => Paramettre.fromJson(e)).toList();
    }
    return null;
  }

  static Future<List<Paramettre>> getData({bool remote = false}) async {
    if (await service.isLoadable() && !remote)
      return await getLocalData() ?? [];
    final List<Paramettre> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Paramettre>> getRemoteData() async {
    try {
      final List data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return data.map((e) => Paramettre.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addData(Paramettre paramettre) async {
    final bool res = await RemoteService.setData(
        collection, paramettre.idParamettre, paramettre.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> updateData(
      String idEdition, Paramettre paramettre) async {
    final bool res =
        await RemoteService.setData(collection, idEdition, paramettre.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> removeData(String idEdition) async {
    final bool res = await RemoteService.deleteData(collection, idEdition);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}

List<Map<String, dynamic>> paramettres = [
  {
    'idParamettre': 'p1',
    'idEdition': 'thialgou2023',
    'success': 4,
    'users': "ibrahimaaboulam@gmail.com,root@gmail.com",
  },
  {
    'idParamettre': 'p2',
    'idEdition': 'district2023',
    'success': 16,
    'users': "amadoulam@gmail.com,root@gmail.com",
  },
];
