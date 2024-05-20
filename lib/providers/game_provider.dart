import 'package:app/collection/game_collection.dart';
import 'package:app/collection/game_event_collection.dart';
import 'package:app/models/game.dart';
import 'package:app/models/gameEvent.dart';
import 'package:app/service/game_service.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  GameCollection gameCollection = GameCollection([]);
  GameEventCollection gameEventCollection = GameEventCollection([]);

  Future<GameCollection> getGames() async {
    if (gameCollection.isEmpty) {
      gameCollection = GameCollection(await GameService().getData);
      notifyListeners();
    }
    return gameCollection;
  }

  Future<GameCollection> getGameEvents() async {
    if (gameEventCollection.isEmpty) {
      gameEventCollection = GameEventCollection([]);
      notifyListeners();
    }
    return gameCollection;
  }

  void changeScore(
      {required String id, required int hs, required int as}) async {
    gameCollection.changeScore(id: id, homeScore: hs, awayScore: as);
    notifyListeners();
  }

  void changeEtat({required String id, required String etat}) async {
    gameCollection.changeEtat(id: id, etat: etat);
    notifyListeners();
  }

  GameEvent getEvent(Game game) {
    if (gameEventCollection.isNotEmpty) {
      final GameEvent? value = gameEventCollection.getElementAt(game.idGame!);
      if (value != null) {
        return value;
      }
    }
    EventStream homeEvent = EventStream(
        idPartcipant: game.idHome!, redCard: 0, yellowCard: 0, pourcent: null);
    EventStream awayEvent = EventStream(
        idPartcipant: game.idAway!, redCard: 0, yellowCard: 0, pourcent: null);
    GameEvent gameEvent = GameEvent(
        idGame: game.idGame!,
        timer: null,
        homeEvent: homeEvent,
        awayEvent: awayEvent);
    gameEventCollection.add(gameEvent);
    return gameEvent;
  }

  void changePourcent(String id, double? pourcent, {TimerEvent? timerEvent}) {
    gameEventCollection.gameEvents = gameEventCollection.gameEvents.map((e) {
      if (e.idGame == id) {
        pourcent = pourcent == null ? null : (pourcent! * 100).toInt() / 100;
        e.homeEvent.pourcent = pourcent;
        e.awayEvent.pourcent = pourcent == null ? null : 1 - pourcent!;
        e.timer = timerEvent;
      }
      return e;
    }).toList();
    notifyListeners();
  }

  void changeCard(
    String id,
  ) {
    gameEventCollection.gameEvents = gameEventCollection.gameEvents.map((e) {
      if (e.idGame == id) {
        e.awayEvent.redCard = 1;
        e.awayEvent.yellowCard = 5;
        e.homeEvent.yellowCard = 7;
        e.homeEvent.redCard = 2;
      }
      return e;
    }).toList();
    notifyListeners();
  }
}
