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
}
