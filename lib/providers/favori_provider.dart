import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriProvider extends ChangeNotifier {
  final String _competition_key = 'competitionfavori';
  final String _equipe_key = 'equipefavori';
  final String _joueur_key = 'joueurfavori';

  List<String> competitions = [];
  List<String> equipes = [];
  List<String> joueurs = [];

  Future<List<String>?> getCompetitions() async {
    competitions = (await _getFavories(_competition_key)) ?? [];
    return competitions;
  }

  Future<List<String>?> getEquipes() async {
    equipes = await _getFavories(_equipe_key) ?? [];
    return equipes;
  }

  Future<List<String>?> getJoueurs() async {
    joueurs = await _getFavories(_joueur_key) ?? [];
    return joueurs;
  }

  void addCompetition(String id) async {
    _addFavori(_competition_key, id);
  }

  void addEquipe(String id) async {
    _addFavori(_equipe_key, id);
  }

  void addJoueur(String id) async {
    _addFavori(_joueur_key, id);
  }

  void deleteCompetition(String id) async {
    _deleteFavori(_competition_key, id);
  }

  void deleteEquipe(String id) async {
    _deleteFavori(_equipe_key, id);
  }

  void deleteJoueur(String id) async {
    await _deleteFavori(_joueur_key, id);
  }

  Future _addFavori(String key, String id) async {
    final List<String>? favoris = await _getFavories(key);

    if (favoris != null) {
      if (favoris.contains(id)) return;
      favoris.add(id);
      await _setFavories(key, favoris.toSet().toList());
      await Future.wait([
        getCompetitions(),
        getEquipes(),
        getJoueurs(),
      ]);
    } else {
      await _setFavories(key, [id]);
    }
    notifyListeners();
  }

  Future _deleteFavori(String key, String id) async {
    final List<String>? favoris = await _getFavories(key);
    if (favoris != null && favoris.contains(id)) {
      favoris.removeWhere((element) => element == id);
      _setFavories(key, favoris);
      await Future.wait([
        getCompetitions(),
        getEquipes(),
        getJoueurs(),
      ]);
      notifyListeners();
    }
  }

  Future<List<String>?> _getFavories(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(key);
  }

  Future _setFavories(String key, List<String> values) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList(key, values);
  }
}
