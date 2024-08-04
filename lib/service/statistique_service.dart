import 'package:app/models/statistique.dart';
import 'package:app/service/local_service.dart';

class StatistiqueService {
  static LocalService get service => LocalService('statistique.json');

  static Future<List<Statistique>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null)
        return data.map((e) => Statistique.fromJson(e)).toList();
    }
    return null;
  }

  static Future<List<Statistique>> getData({bool remote = false}) async {
    final List<Statistique> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Statistique>> getRemoteData() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (stats.isNotEmpty) await service.setData(stats);
      return stats.map((e) => Statistique.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addStatistique(Statistique stat) async {
    stats.add(stat.toJson());
    await service.setData(stats);
    return true;
  }

  static Future<bool> editStatistique(
      String idStatistique, Statistique stat) async {
    if (stats.any((element) => element['idStatistique'] == idStatistique)) {
      int index = stats
          .indexWhere((element) => element['idStatistique'] == idStatistique);
      if (index >= 0) stats[index] = stat.toJson();
      await service.setData(stats);
      return true;
    }
    return false;
  }

  static Future<bool> deleteStatistique(String idStatistique) async {
    if (stats.any((element) => element['idStatistique'] == idStatistique)) {
      stats.removeWhere((element) => element['idStatistique'] == idStatistique);
      await service.setData(stats);
      return true;
    }
    return false;
  }
}

List<Map<String, dynamic>> stats = [];
