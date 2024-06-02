import 'package:app/collection/collection.dart';
import 'package:app/models/statistique.dart';

class StatistiqueCollection extends Collection {
  List<Statistique> _statistiques;
  StatistiqueCollection(this._statistiques);

  List<Statistique> get statistiques => _statistiques;

  void set statistiques(List<Statistique> val) => _statistiques = val;

  @override
  getElementAt(String id) {}

  @override
  bool get isEmpty => _statistiques.isEmpty;

  @override
  bool get isNotEmpty => _statistiques.isNotEmpty;

  List<Statistique> getGameStatistiques(String idGame) {
    return statistiques.where((element) => element.idGame == idGame).toList();
  }

  void addGameStatistique(Statistique statistique) {
    _statistiques.add(statistique);
  }
}
