import 'package:app/core/params/categorie/categorie_params.dart';
import 'package:app/models/sponsor.dart';
import 'package:app/service/sponsor_service.dart';
import 'package:flutter/material.dart';

class SponsorProvider extends ChangeNotifier {
  List<Sponsor> _sponsors;
  SponsorProvider([this._sponsors = const []]);

  List<Sponsor> get sponsors => _sponsors;
  void set sponsors(List<Sponsor> val) {
    _sponsors = val;
    notifyListeners();
  }

  Future<List<Sponsor>> getData({bool remote = false}) async {
    if (sponsors.isEmpty || remote) {
      sponsors = await SponsorService.getData(remote: remote);
    }
    return sponsors;
  }

  List<Sponsor> getSponsorBy(
      {required CategorieParams? categorie, String? idSponsorExclus}) {
    if (categorie == null) return [];
    if (categorie.isNull) return [];
    List<Sponsor> listes = sponsors;
    if (idSponsorExclus != null) {
      listes = listes
          .where((element) => element.idSponsor != idSponsorExclus)
          .toList();
    }
    if (categorie.idJoueur != null) {
      listes = listes
          .where((element) => element.idJoueur == categorie.idJoueur)
          .toList();
      return listes;
    }
    if (categorie.idParticipant != null) {
      listes = listes
          .where((element) => element.idParticipant == categorie.idParticipant)
          .toList();
      return listes;
    }
    if (categorie.idParticipant2 != null) {
      listes = listes
          .where((element) => element.idParticipant == categorie.idParticipant2)
          .toList();
      return listes;
    }
    if (categorie.idGame != null) {
      listes = listes
          .where((element) => element.idGame == categorie.idGame)
          .toList();
      return listes;
    }

    if (categorie.idEdition != null) {
      listes = listes
          .where((element) => element.idEdition == categorie.idEdition)
          .toList();
      return listes;
    }

    return [];
  }

  Future<bool> addSponsor(Sponsor info) async {
    final result = await SponsorService.addSponsor(info);
    if (result) {
      await getData(remote: true);
    }
    return result;
  }

  Future<bool> editSponsor(String id, Sponsor info) async {
    final result = await SponsorService.editSponsor(id, info);
    if (result) {
      await getData(remote: true);
    }
    return result;
  }

  Future<bool> deleteSponsor(String id) async {
    final result = await SponsorService.deleteSponsor(id);
    if (result) {
      await getData(remote: true);
    }
    return result;
  }
}
