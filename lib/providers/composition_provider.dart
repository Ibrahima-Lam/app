import 'package:app/collection/composition_collection.dart';
import 'package:app/core/extension/list_extension.dart';

import 'package:app/models/composition.dart';
import 'package:app/models/event.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/service/composition_service.dart';
import 'package:flutter/material.dart';

class CompositionProvider extends ChangeNotifier {
  CompositionCollection compositionCollection = CompositionCollection([]);
  GameEventListProvider gameEventListProvider;
  CompositionProvider(
      {required this.compositionCollection,
      required this.gameEventListProvider}) {
    compositionCollection.compositions =
        compositionCollection.compositions.map(_toElement).toList();
  }
  Composition _toElement(e) {
    if (e is JoueurComposition) {
      List<Event> evs = gameEventListProvider.getJoueurGameEvent(
          idGame: e.idGame, idJoueur: e.idJoueur, target: true);
      int but = evs
          .whereType<GoalEvent>()
          .where((element) => element.propre && element.idJoueur == e.idJoueur)
          .length;
      int jaune =
          evs.whereType<CardEvent>().where((element) => !element.isRed).length;
      int rouge =
          evs.whereType<CardEvent>().where((element) => element.isRed).length;
      e.but = but;
      e.jaune = jaune;
      e.rouge = rouge;
      List<RemplEvent> rempl = evs.whereType<RemplEvent>().toList();
      if (rempl.isEmpty) {
        e.entrant = null;
        e.sortant = null;
        return e;
      }
      RemplEvent? on =
          rempl.singleWhereOrNull((element) => element.idJoueur == e.idJoueur);
      if (on != null) {
        e.entrant = compositionCollection.compositions
            .whereType<JoueurComposition>()
            .toList()
            .singleWhereOrNull((element) =>
                element.idJoueur == on.idTarget && element.idGame == on.idGame);
      }
      RemplEvent? off =
          rempl.singleWhereOrNull((element) => element.idTarget == e.idJoueur);
      if (off != null) {
        e.sortant = compositionCollection.compositions
            .whereType<JoueurComposition>()
            .toList()
            .singleWhereOrNull((element) =>
                element.idJoueur == off.idJoueur &&
                element.idGame == off.idGame);
      }
    }
    return e;
  }

  Future setCollection() async {
    compositionCollection = CompositionCollection(
        (await CompositionService.getData()).map(_toElement).toList());
    notifyListeners();
  }

  Future<CompositionCollection> getCompositions({bool remote = false}) async {
    if (compositionCollection.isEmpty || remote) {
      await setCollection();
    }
    return compositionCollection;
  }

  Future<bool> addAllCompositions(
      String idGame, List<Composition> compos) async {
    await CompositionService.addAllCompositions(idGame, compos);
    await setCollection();
    return true;
  }

  Future<bool> setAllCompositions(
      String idGame, List<Composition> compos) async {
    final bool result =
        await CompositionService.setAllCompositions(idGame, compos);
    if (result) {
      await setCollection();
    }
    return result;
  }

  Future<bool> editComposition(String idComposition, Composition stat) async {
    final result =
        await CompositionService.editComposition(idComposition, stat);
    if (result) {
      await setCollection();
    }
    return result;
  }

  Future<bool> setComposition(String idComposition, Composition stat) async {
    final result = await CompositionService.setComposition(idComposition, stat);
    if (result) {
      await setCollection();
    }
    return result;
  }

  Future<bool> deleteComposition(String idComposition) async {
    final result = await CompositionService.deleteComposition(idComposition);
    if (result) {
      await setCollection();
    }
    return result;
  }

  Future<bool> addComposition(Composition competition) async {
    final result = await CompositionService.addComposition(competition);
    if (result) {
      await setCollection();
    }
    return result;
  }
}
