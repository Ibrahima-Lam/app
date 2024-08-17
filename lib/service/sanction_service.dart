import 'package:app/models/event.dart';
import 'package:app/core/service/local_service.dart';
import 'package:app/core/service/remote_service.dart';

class SanctionService {
  static LocalService get service => LocalService('sanction.json');
  static const String collection = 'sanction';

  static Future<List<CardEvent>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null) return data.map((e) => CardEvent.fromJson(e)).toList();
    }
    return null;
  }

  static Future<List<CardEvent>> getData({bool remote = false}) async {
    final List<CardEvent> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<CardEvent>> getRemoteData() async {
    try {
      final List data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return data.map((e) => CardEvent.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addCardEvent(CardEvent event) async {
    final bool res =
        await RemoteService.setData(collection, event.idEvent, event.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> editCardEvent(
      String idSanctionner, CardEvent event) async {
    final bool res =
        await RemoteService.setData(collection, idSanctionner, event.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> deleteCardEvent(String idSanctionner) async {
    final bool res = await RemoteService.deleteData(collection, idSanctionner);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}
