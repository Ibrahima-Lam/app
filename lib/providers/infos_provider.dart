import 'package:app/core/params/categorie/categorie_params.dart';
import 'package:app/models/infos/infos.dart';
import 'package:app/service/infos_service.dart';
import 'package:flutter/material.dart';

class InfosProvider extends ChangeNotifier {
  List<Infos> infos = [];
  InfosProvider() {
    InfosService.getData().listen(
      (inf) {
        infos.add(inf);
        notifyListeners();
      },
    );
  }

  Stream<Infos> getInformations() async* {
    /*  if (infos.isEmpty) {
      await for (Infos inf in InfosService.getData()) {
        infos.add(inf);
        yield inf;
      }
    } */
  }

  /* List<Infos> getInfosByInfo({required Infos info}) {
    List<Infos> listes = getInfosBy(
      idEdition: info.idEdition,
      idGame: info.idGame,
      idJoueur: info.idJoueur,
      idParticipant: info.idParticipant,
    );
    return listes;
  } */

  List<Infos> getInfosBy({required CategorieParams? categorie}) {
    if (categorie == null) return [];
    if (categorie.isNull) return [];
    List<Infos> listes = infos;
    if (categorie.idEdition != null)
      listes = listes
          .where((element) => element.idEdition == categorie.idEdition)
          .toList();
    if (categorie.idGame != null)
      listes = listes
          .where((element) => element.idGame == categorie.idGame)
          .toList();
    if (categorie.idParticipant != null)
      listes = listes
          .where((element) => element.idParticipant == categorie.idParticipant)
          .toList();
    if (categorie.idParticipant2 != null)
      listes = listes
          .where((element) => element.idParticipant == categorie.idParticipant2)
          .toList();
    if (categorie.idJoueur != null)
      listes = listes
          .where((element) => element.idJoueur == categorie.idJoueur)
          .toList();
    return listes;
  }
}
