import 'package:app/models/event.dart';
import 'package:app/models/game.dart';
import 'package:app/service/event_service.dart';
import 'package:flutter/material.dart';

class GameEventListProvider extends ChangeNotifier {
  List<Event> _events;

  GameEventListProvider(this._events) {
    EventService().getData().then((value) {
      _events = value;
      notifyListeners();
    });
  }

  List<Event> get events => _events;

  void set events(List<Event> val) => _events = val;

  Future<List<Event>> getGameEvents({required String idGame}) async {
    if (events.isNotEmpty) return events;
    events = await EventService().getData();
    return events.where((element) => element.idGame == idGame).toList();
  }

  (int, int) getYellowCardStat(Game game) {
    final int home = getGameCardEvents(idGame: game.idGame, isRed: false)
        .where((element) => element.idParticipant == game.idHome)
        .fold(0, (previousValue, element) => previousValue + 1);
    final int away = getGameCardEvents(idGame: game.idGame, isRed: false)
        .where((element) => element.idParticipant == game.idAway)
        .fold(0, (previousValue, element) => previousValue + 1);
    return (home, away);
  }

  (int, int) getRedCardStat(Game game) {
    final int home = getGameCardEvents(idGame: game.idGame, isRed: true)
        .where((element) => element.idParticipant == game.idHome)
        .fold(0, (previousValue, element) => previousValue + 1);
    final int away = getGameCardEvents(idGame: game.idGame, isRed: true)
        .where((element) => element.idParticipant == game.idAway)
        .fold(0, (previousValue, element) => previousValue + 1);
    return (home, away);
  }

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  List<GoalEvent> getGameGoalsEvents(
      {required String idGame, required String idParticipant}) {
    List<GoalEvent> evenement = events
        .whereType<GoalEvent>()
        .where((element) => element.idGame == idGame)
        .toList();

    return evenement;
  }

  List<CardEvent> getGameCardEvents(
      {required String idGame, bool isRed = false}) {
    List<CardEvent> evenement = events
        .whereType<CardEvent>()
        .where((element) => element.idGame == idGame && element.isRed == isRed)
        .toList();

    return evenement;
  }

  List<RemplEvent> getGameSubstitutionEvents({
    required String idGame,
    required String idParticipant,
  }) {
    List<RemplEvent> evenement = events
        .whereType<RemplEvent>()
        .where((element) => element.idGame == idGame)
        .toList();

    return evenement;
  }
}
