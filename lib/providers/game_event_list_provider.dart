import 'package:app/collection/game_event_list_collection.dart';
import 'package:app/models/event.dart';
import 'package:app/service/but_service.dart';
import 'package:app/service/sanction_service.dart';
import 'package:flutter/material.dart';

class GameEventListProvider extends ChangeNotifier {
  GameEventListCollection collection = GameEventListCollection([]);

  Future<void> setCollection() async {
    collection = GameEventListCollection(
        [...await ButService.getData, ...await SanctionService.getData]);
    notifyListeners();
  }

  Future<GameEventListCollection> getGameEvents(
      {required String idGame}) async {
    if (collection.isEmpty) {
      await setCollection();
    }
    return collection;
  }

  Future addEvent(Event event) async {
    collection.add(event);
    notifyListeners();
  }
}
