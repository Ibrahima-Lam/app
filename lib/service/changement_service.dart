import 'package:app/models/event.dart';
import 'package:app/service/local_service.dart';

class ChangementService {
  static LocalService get service => LocalService('changement.json');

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
      await Future.delayed(const Duration(seconds: 1));
      if (changements.isNotEmpty) await service.setData(changements);
      return changements.map((e) => RemplEvent.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addRemplEvent(RemplEvent event) async {
    changements.add(event.toJson());
    await service.setData(changements);
    return true;
  }

  static Future<bool> editRemplEvent(
      String idChangement, RemplEvent event) async {
    if (changements
        .any((element) => element['idChangement'].toString() == idChangement)) {
      int index = changements.indexWhere(
          (element) => element['idChangement'].toString() == idChangement);
      if (index >= 0) changements[index] = event.toJson();
      await service.setData(changements);

      return true;
    }
    return false;
  }

  static Future<bool> deleteRemplEvent(String idChangement) async {
    print(idChangement);
    print(changements);
    if (changements
        .any((element) => element['idChangement'].toString() == idChangement)) {
      changements.removeWhere(
          (element) => element['idChangement'].toString() == idChangement);
      await service.setData(changements);

      return true;
    }
    return false;
  }
}

List<Map<String, dynamic>> changements = [];
