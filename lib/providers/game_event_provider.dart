import 'package:app/models/game.dart';
import 'package:app/models/gameEvent.dart';
import 'package:flutter/material.dart';

class GameEventProvider extends ChangeNotifier {
  List<GameEvent> gameEvents = [];

  Future<GameEvent> getEvent(Game game) async {
    EventStream homeEvent = EventStream(
        idPartcipant: game.idHome!,
        redCard: 0,
        yellowCard: 0,
        goal: 0,
        pourcent: 0.4);
    EventStream awayEvent = EventStream(
        idPartcipant: game.idAway!,
        redCard: 0,
        yellowCard: 0,
        goal: 0,
        pourcent: 1 - homeEvent.pourcent!);
    return GameEvent(
        idGame: game.idGame!, homeEvent: homeEvent, awayEvent: awayEvent);
  }
}
