import 'package:app/models/statistique.dart';
import 'package:app/service/statistique_service.dart';
import 'package:flutter/material.dart';

class StatistiqueFutureProvider extends ChangeNotifier {
  List<Statistique> _statistiques;
  StatistiqueFutureProvider(this._statistiques) {
    StatistiqueService.getData().then((value) {
      _statistiques = value;
      notifyListeners();
    });
  }

  Future<void> getData({bool remote = false}) async {
    _statistiques = await StatistiqueService.getData(remote: remote);
    notifyListeners();
  }

  List<Statistique> get statistiques => _statistiques;
  void set statistiques(List<Statistique> val) {
    _statistiques = val;
    notifyListeners();
  }

  Future<bool> addStatistique(Statistique stat) async {
    final result = await StatistiqueService.addStatistique(stat);
    if (result) await getData(remote: true);
    return result;
  }

  Future<bool> editStatistique(String idStatistique, Statistique stat) async {
    final result =
        await StatistiqueService.editStatistique(idStatistique, stat);
    if (result) await getData(remote: true);
    return result;
  }

  Future<bool> deleteStatistique(String idStatistique) async {
    final result = await StatistiqueService.deleteStatistique(idStatistique);
    if (result) await getData(remote: true);
    return result;
  }
}
