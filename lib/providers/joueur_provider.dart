import 'package:app/models/joueur.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/service/joueur_service.dart';
import 'package:flutter/material.dart';

class JoueurProvider extends ChangeNotifier {
  List<Joueur> _joueurs;
  ParticipantProvider participantProvider;
  JoueurProvider(
    this._joueurs, {
    required this.participantProvider,
  });
  List<Joueur> get joueurs => _joueurs;

  Future<void> setJoueurs() async {
    if (participantProvider.participants.isEmpty)
      await participantProvider.getParticipants();
    _joueurs = await JoueurService().getData(participantProvider.participants);
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
