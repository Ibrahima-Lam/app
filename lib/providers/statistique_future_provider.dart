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

  List<Statistique> get statistiques => _statistiques;
  void set statistiques(List<Statistique> val) {
    _statistiques = val;
    notifyListeners();
  }

  void addStat(Statistique statistique) {
    _statistiques.add(statistique);
    notifyListeners();
  }

  void setStat(Statistique statistique) {
    notifyListeners();
  }
}
