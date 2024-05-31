import 'package:app/collection/game_event_list_collection.dart';
import 'package:app/models/event.dart';
import 'package:flutter/material.dart';

class GameEventListProvider extends ChangeNotifier {
  GameEventListCollection collection = GameEventListCollection([]);

  Future<GameEventListCollection> getGameEvents(
      {required String idGame}) async {
    return collection;
  }

  Future addEvent(Event event) async {
    collection.add(event);
    notifyListeners();
  }
}
