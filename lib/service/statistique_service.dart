import 'dart:math';

import 'package:app/core/extension/string_extension.dart';
import 'package:app/models/statistique.dart';
import 'package:app/service/local_service.dart';
import 'package:flutter/material.dart';

final Map<String, String> entries = {
  'corner': 'Corners',
  'touche': 'Touches',
  'occasion': 'Occasions',
  'jaune': 'Cartons Jaunes',
  'rouge': 'Cartons Rouges',
  'tir': 'Tirs',
  'tir-cadre': 'Tirs Cadrés',
  'faute': 'Fautes',
};
ValueNotifier<List<Statistique>> stats = ValueNotifier([
  Statistique(
      idStatistique: 'S',
      codeStatistique: 'possession',
      nomStatistique: 'Possession',
      homeStatistique: 60,
      awayStatistique: 40,
      idGame: 'G'),
  ...entries.entries.map(
    (m) => Statistique(
        idStatistique: 'S${m.key}',
        codeStatistique: m.key,
        nomStatistique: m.value.toString().capitalize(),
        homeStatistique: Random().nextInt(10).toDouble(),
        awayStatistique: Random().nextInt(10).toDouble(),
        idGame: 'G${m.key}'),
  )
]);

class StatistiqueService {
  static Future<void> setStat(Statistique stat,
      {required String idGame, required String codeStatistique}) async {
    stats.value.removeWhere((element) =>
        element.idGame == idGame && element.codeStatistique == codeStatistique);
    stats.value.add(stat);
  }

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
      if (stats.value.isNotEmpty) await service.setData(stats.value);
      return stats.value;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addStatistique(Statistique stat) async {
    stats.value.add(stat);
    return true;
  }

  static Future<bool> editStatistique(String idBut, Statistique stat) async {
    if (stats.value.any((element) => element.idStatistique == idBut)) {
      int index =
          stats.value.indexWhere((element) => element.idStatistique == idBut);
      if (index >= 0) stats.value[index] = stat;
      return true;
    }
    return false;
  }

  static Future<bool> deleteStatistique(String idBut) async {
    if (stats.value.any((element) => element.idStatistique == idBut)) {
      stats.value.removeWhere((element) => element.idStatistique == idBut);
      return true;
    }
    return true;
  }
}
