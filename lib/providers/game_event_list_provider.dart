import 'package:app/core/enums/event_type_enum.dart';
import 'package:app/models/event.dart';
import 'package:app/models/game.dart';
import 'package:app/service/but_service.dart';
import 'package:app/service/changement_service.dart';
import 'package:app/service/event_service.dart';
import 'package:app/service/sanction_service.dart';
import 'package:flutter/material.dart';

class GameEventListProvider extends ChangeNotifier {
  List<Event> _events;

  GameEventListProvider(this._events);

  List<Event> get events => _events;

  void set events(List<Event> val) => _events = val
    ..sort(
      (a, b) {
        try {
          if ((int.tryParse(a.minute ?? '0') ?? 0) -
                  (int.tryParse(b.minute ?? '0') ?? 0) !=
              0)
            return (int.tryParse(a.minute ?? '0') ?? 0) -
                (int.tryParse(b.minute ?? '0') ?? 0);
          return a.idEvent.compareTo(b.idEvent);
        } catch (e) {
          return 0;
        }
      },
    );
  Future<void> getEvents({bool remote = false}) async {
    if (events.isEmpty || remote)
      events = await EventService().getData(remote: remote);
  }

  Future<void> updateEvents() async {
    events = await EventService().getData();
    notifyListeners();
  }

  Future<List<Event>> getGameEvents({required String idGame}) async {
    if (events.isNotEmpty) return events;
    events = await EventService().getData();
    return events.where((element) => element.idGame == idGame).toList();
  }

  Future<List<Event>> getEquipeEvents({required String idParticipant}) async {
    if (events.isNotEmpty) return events;
    events = await EventService().getData();
    return events
        .where((element) => element.idParticipant == idParticipant)
        .toList();
  }

  List<Event> getJoueurGameEvent(
      {required String idGame, required String idJoueur, bool target = false}) {
    return events
        .where((element) =>
            (element.idJoueur == idJoueur ||
                element.idTarget == idJoueur && target) &&
            element.idGame == idGame)
        .toList();
  }

  List<Event> getEquipeGameEvent(
      {required String idGame, required String idParticipant}) {
    return events
        .where((element) =>
            element.idParticipant == idParticipant && element.idGame == idGame)
        .toList();
  }

  void setJoueurGameEventNom(List<Event> evs, String nom) {
    for (Event ev in evs) {
      int index =
          events.lastIndexWhere((element) => element.idEvent == ev.idEvent);
      events[index].nom = nom;
    }
    notifyListeners();
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

  Future<bool> addEvent(Event event) async {
    bool result = false;
    if (event is GoalEvent) result = await ButService.addGoalEvent(event);
    if (event is CardEvent) result = await SanctionService.addCardEvent(event);
    if (event is RemplEvent)
      result = await ChangementService.addRemplEvent(event);
    if (result) updateEvents();
    return true;
  }

  Future<bool> editEvent(String idEvent, Event event) async {
    bool result = false;
    if (event is GoalEvent)
      result = await ButService.editGoalEvent(idEvent, event);
    if (event is CardEvent)
      result = await SanctionService.editCardEvent(idEvent, event);
    if (event is RemplEvent)
      result = await ChangementService.editRemplEvent(idEvent, event);
    if (result) updateEvents();
    return result;
  }

  Future<bool> deleteEvent(String idEvent, EventType type) async {
    bool result = false;
    if (type == EventType.but)
      result = await ButService.deleteGoalEvent(idEvent);
    if (type == EventType.jaune || type == EventType.rouge)
      result = await SanctionService.deleteCardEvent(idEvent);
    if (type == EventType.changement)
      result = await ChangementService.deleteRemplEvent(idEvent);
    if (result) updateEvents();
    return result;
  }
}
