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

  static Future<List<Arbitre>> getArbitres() async {
    if (await service.isLoadable()) return await getLocalData() ?? [];
    await Future.delayed(const Duration(seconds: 1));
    // Todo changer arbitres par remote data
    await service.setData(arbitres);
    return arbitres.map((e) => Arbitre.fromJson(e)).toList();
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
