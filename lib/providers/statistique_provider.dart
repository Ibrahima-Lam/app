import 'dart:math';

import 'package:app/collection/statistique_collection.dart';
import 'package:app/core/extension/string_extension.dart';
import 'package:app/models/statistique.dart';
import 'package:flutter/material.dart';

class StatistiqueProvider extends ChangeNotifier {
  StatistiqueCollection collection = StatistiqueCollection([]);

  Future<StatistiqueCollection> getStatistiques(String idGame) async {
    await Future.delayed(const Duration(seconds: 1));
    collection.statistiques = [
      Statistique(
          idStatistique: 'S',
          codeStatistique: 'possession',
          nomStatistique: 'Possession',
          homeStatistique: 40,
          awayStatistique: 60,
          idGame: 'G'),
      ...['corner', 'touche', 'occasion', 'jaune', 'rouge', 'tir', 'tir cadres']
          .asMap()
          .entries
          .map(
            (m) => Statistique(
                idStatistique: 'S${m.key}',
                codeStatistique: m.value,
                nomStatistique: m.value.toString().capitalize(),
                homeStatistique: Random().nextInt(10).toDouble(),
                awayStatistique: Random().nextInt(10).toDouble(),
                idGame: 'G${m.key}'),
          )
    ];
    return collection;
  }

  Future<void> addStatistiques() async {
    collection.addGameStatistique(Statistique(
        idStatistique: 'S1',
        codeStatistique: 'score',
        nomStatistique: 'Score',
        homeStatistique: 1,
        awayStatistique: 0,
        idGame: 'G1'));
    notifyListeners();
  }
}
