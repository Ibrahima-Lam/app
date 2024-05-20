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
    await setCollection();
    return compositionCollection;
  }

  Future<void> setCompositions(String idGame, List<Composition> compos) async {
    await CompositionService.setCompositions(idGame, compos);
    setCollection();
  }
}
