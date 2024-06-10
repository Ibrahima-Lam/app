import 'package:app/models/joueur.dart';
import 'package:app/service/joueur_service.dart';
import 'package:flutter/material.dart';

class JoueurProvider extends ChangeNotifier {
  List<Joueur> _joueurs = [];

  List<Joueur> get joueurs => _joueurs;

  Future<void> setJoueurs() async {
    _joueurs = await JoueurService().getData();
    notifyListeners();
  }

  Future<List<Joueur>> getJoueurs() async {
    if (_joueurs.isEmpty) {
      await setJoueurs();
    }
    return _joueurs;
  }

  Future<List<Joueur>> getJoueursBy({
    String? idParticipant,
  }) async {
    if (_joueurs.isEmpty) {
      await setJoueurs();
    }
    List<Joueur> joueurs = _joueurs;
    if (idParticipant != null) {
      joueurs = joueurs
          .where((element) => element.idParticipant == idParticipant)
          .toList();
    }
    return joueurs;
  }

  Future<Joueur> getJoueursByid(String id) async {
    if (_joueurs.isEmpty) {
      await setJoueurs();
    }
    return _joueurs.firstWhere((element) => element.idJoueur == id);
  }

  Future<bool> checkId(String id) async {
    if (_joueurs.isEmpty) {
      await setJoueurs();
    }
    return _joueurs.any((element) => element.idJoueur == id);
  }
}
