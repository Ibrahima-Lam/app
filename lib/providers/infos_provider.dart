import 'package:app/core/params/categorie/categorie_params.dart';
import 'package:app/models/infos/infos.dart';
import 'package:app/service/infos_service.dart';
import 'package:flutter/material.dart';

class InfosProvider extends ChangeNotifier {
  List<Infos> _infos;
  InfosProvider([this._infos = const []]);

  List<Infos> get infos => _infos;
  void set infos(List<Infos> val) {
    _infos = val;
    notifyListeners();
  }

  Future<List<Infos>> getInformations({bool remote = false}) async {
    if (infos.isEmpty || remote) {
      infos = await InfosService.getData(remote: remote);
    }
    return infos;
  }

  List<Infos> getInfosBy(
      {required CategorieParams? categorie, String? idInfosExclus}) {
    if (categorie == null) return [];
    if (categorie.isNull) return [];
    List<Infos> listes = infos;
    if (idInfosExclus != null) {
      listes =
          listes.where((element) => element.idInfos != idInfosExclus).toList();
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

  Future<bool> addInfos(Infos info) async {
    final result = await InfosService.addInfos(info);
    if (result) {
      await getInformations(remote: true);
    }
    return result;
  }

  Future<bool> editInfos(String id, Infos info) async {
    final result = await InfosService.editInfos(id, info);
    if (result) {
      print("ok");
      await getInformations(remote: true);
    }
    return result;
  }

  Future<bool> deleteInfos(String id) async {
    final result = await InfosService.deleteInfos(id);
    if (result) {
      await getInformations(remote: true);
    }
    return result;
  }
}
