import 'dart:math';

import 'package:app/core/extension/string_extension.dart';
import 'package:app/models/statistique.dart';
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
  static Future<List<Statistique>> getData() async {
    await Future.delayed(const Duration(seconds: 1));

    return stats.value;
  }

  static Future<void> setStat(Statistique stat,
      {required String idGame, required String codeStatistique}) async {
    stats.value.removeWhere((element) =>
        element.idGame == idGame && element.codeStatistique == codeStatistique);
    stats.value.add(stat);
  }
}
