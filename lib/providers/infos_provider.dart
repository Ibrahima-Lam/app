import 'package:app/models/infos/infos.dart';
import 'package:app/service/infos_service.dart';
import 'package:flutter/material.dart';

class InfosProvider extends ChangeNotifier {
  List<Infos> infos = [];

  Stream<Infos> getInformations() async* {
    if (infos.isEmpty) {
      await for (Infos inf in InfosService.getData()) {
        infos.add(inf);
        yield inf;
      }
    }
  }

  List<Infos> getInfosByInfo({required Infos info}) {
    List<Infos> listes = getInfosBy(
      idEdition: info.idEdition,
      idGame: info.idGame,
      idJoueur: info.idJoueur,
      idPartcipant: info.idPartcipant,
    );
    return listes;
  }

  List<Infos> getInfosBy({
    String? idEdition,
    String? idGame,
    String? idJoueur,
    String? idPartcipant,
  }) {
    if ((idEdition, idGame, idPartcipant, idJoueur)
        case (null, null, null, null)) return [];
    List<Infos> listes = infos;
    if (idEdition != null)
      listes =
          listes.where((element) => element.idEdition == idEdition).toList();
    if (idGame != null)
      listes = listes.where((element) => element.idGame == idGame).toList();
    if (idPartcipant != null)
      listes = listes
          .where((element) => element.idPartcipant == idPartcipant)
          .toList();
    if (idJoueur != null)
      listes = listes.where((element) => element.idJoueur == idJoueur).toList();
    return listes;
  }
}
