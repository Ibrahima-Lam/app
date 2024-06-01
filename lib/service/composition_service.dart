import 'package:app/models/composition.dart';
import 'package:flutter/material.dart';

ValueNotifier<List<Composition>> compositions = ValueNotifier([]);

class CompositionService {
  static Future<List<Composition>> getCompositions() async {
    await Future.delayed(Duration(seconds: 1));
    return compositions.value;
  }

  static Future<void> setCompositions(
      String idGame, List<Composition> compos) async {
    final List<Composition> data = compositions.value
        .where((element) => element.idGame != idGame)
        .toList();
    data.addAll(compos);
    compositions.value = data;
  }

  static Future<void> setJoueurComposition(JoueurComposition composition,
      {required String idGame,
      required String idParticipant,
      required String idJoueur}) async {
    final bool Function(Composition) fn = (element) =>
        (element as JoueurComposition).idGame == idGame &&
        (element).idParticipant == idParticipant &&
        (element).idJoueur == idJoueur;
    final bool check =
        compositions.value.whereType<JoueurComposition>().any(fn);
    if (!check) return;
    final int index = compositions.value.indexWhere(
      (element) {
        if (element is! JoueurComposition) return false;
        return fn(element);
      },
    );
    compositions.value[index] = composition;
  }
}
