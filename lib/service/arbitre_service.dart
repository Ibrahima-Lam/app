import 'package:app/models/arbitres/arbitre.dart';
import 'package:app/service/local_service.dart';

class ArbitreService {
  static LocalService get service => LocalService('arbitre.json');

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
      await Future.delayed(const Duration(seconds: 1));
      if (arbitres.isNotEmpty) await service.setData(arbitres);
      return arbitres.map((e) => Arbitre.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addArbitre(Arbitre arbitre) async {
    if (arbitres.any((element) =>
        element['idEdition'] == arbitre.idEdition &&
        element['nomArbitre'] == arbitre.nomArbitre)) return false;
    arbitres.add(arbitre.toJson());
    return true;
  }

  static Future<bool> editArbitre(String idArbitre, Arbitre arbitre) async {
    if (arbitres.any((element) => element['idArbitre'] == idArbitre)) {
      int index =
          arbitres.indexWhere((element) => element['idArbitre'] == idArbitre);
      if (index >= 0) arbitres[index] = arbitre.toJson();
      return true;
    }
    return false;
  }

  static Future<bool> deleteArbitre(String idArbitre) async {
    if (arbitres.any((element) => element['idArbitre'] == idArbitre)) {
      arbitres.removeWhere((element) => element['idArbitre'] == idArbitre);
      return true;
    }
    return false;
  }
}

List<Map<String, dynamic>> arbitres = [
  {
    'idArbitre': 'a1',
    'nomArbitre': 'Ibrahima Sy',
    'role': 'principale',
    'idEdition': 'thialgou2023',
    'imageUrl': '',
  },
  {
    'idArbitre': 'a2',
    'nomArbitre': 'Siley Sy',
    'role': 'principale',
    'imageUrl': '',
    'idEdition': 'thialgou2023',
  },
  {
    'idArbitre': 'a3',
    'nomArbitre': 'Alisein dia',
    'role': 'assistant',
    'idEdition': 'thialgou2023',
    'imageUrl': '',
  },
  {
    'idArbitre': 'a4',
    'nomArbitre': 'Saidou Bocar',
    'role': 'assistant',
    'idEdition': 'thialgou2023',
    'imageUrl': '',
  },
];
