import 'dart:math';

import 'package:app/core/extension/string_extension.dart';
import 'package:app/models/statistique.dart';
import 'package:flutter/material.dart';

ValueNotifier<List<Statistique>> stats = ValueNotifier([
  Statistique(
      idStatistique: 'S',
      codeStatistique: 'possession',
      nomStatistique: 'Possession',
      homeStatistique: 60,
      awayStatistique: 40,
      idGame: 'G'),
  ...[
    'corners',
    'touches',
    'occasions',
    'cartons jaunes',
    'cartons rouges',
    'tirs',
    'tirs cadres'
  ].asMap().entries.map(
        (m) => Statistique(
            idStatistique: 'S${m.key}',
            codeStatistique: m.value,
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
