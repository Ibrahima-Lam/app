import 'package:app/collection/composition_collection.dart';

import 'package:app/models/composition.dart';
import 'package:app/service/composition_service.dart';
import 'package:flutter/material.dart';

class CompositionProvider extends ChangeNotifier {
  CompositionCollection compositionCollection = CompositionCollection([]);

  Future setCollection() async {
    compositionCollection =
        CompositionCollection(await CompositionService.getCompositions());
    notifyListeners();
  }

  Future<CompositionCollection> getCompositions() async {
    if (compositionCollection.isEmpty) {
      await setCollection();
    }
    return compositionCollection;
  }

  Future<void> setCompositions(String idGame, List<Composition> compos) async {
    await CompositionService.setCompositions(idGame, compos);
    setCollection();
  }

  Future<bool> removeComposition(String id) async {
    compositionCollection.compositions
        .removeWhere((element) => element.idComposition == id);
    notifyListeners();
    return true;
  }

  Future<void> setJoueurComposition(JoueurComposition composition,
      {required String idGame,
      required String idParticipant,
      required String idJoueur}) async {
    CompositionService.setJoueurComposition(composition,
        idGame: idGame, idParticipant: idParticipant, idJoueur: idJoueur);
    setCollection();
  }

  Future<bool> editComposition(String idComposition, Composition stat) async {
    final result =
        await CompositionService.editComposition(idComposition, stat);
    if (result) {
      setCollection();
    }
    return result;
  }

  Future<bool> deleteComposition(String idComposition) async {
    final result = await CompositionService.deleteComposition(idComposition);
    if (result) {
      setCollection();
    }
    return result;
  }

  Future<bool> addComposition(Composition competition) async {
    final result = await CompositionService.addComposition(competition);
    if (result) {
      setCollection();
    }
    return result;
  }
}
