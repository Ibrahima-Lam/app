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

  Future<void> setJoueurs({bool remote = false}) async {
    if (participantProvider.participants.isEmpty || remote)
      await participantProvider.getParticipants();
    _joueurs = await JoueurService.getData(participantProvider.participants,
        remote: remote);
    notifyListeners();
  }

  Future<List<Joueur>> getJoueurs({bool remote = false}) async {
    if (_joueurs.isEmpty || remote) {
      await setJoueurs(remote: remote);
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

  Future<bool> addJoueur(Joueur joueur) async {
    final result = await JoueurService.addJoueur(joueur);
    if (result) await setJoueurs(remote: true);
    return result;
  }

  Future<bool> editJoueur(String idJoueur, Joueur joueur) async {
    final result = await JoueurService.editJoueur(idJoueur, joueur);
    if (result) await setJoueurs(remote: true);
    return result;
  }

  Future<bool> deleteJoueur(String idJoueur) async {
    final result = await JoueurService.deleteJoueur(idJoueur);
    if (result) await setJoueurs(remote: true);
    return result;
  }
}
