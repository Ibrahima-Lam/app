import 'package:app/collection/collection.dart';
import 'package:app/models/Event.dart';
import 'package:app/models/game.dart';

class GameEventListCollection extends Collection {
  List<Event> _events;

  GameEventListCollection(this._events);

  List<Event> get events => _events;

  void set events(List<Event> val) => _events = val;
  @override
  getElementAt(String id) {}

  @override
  bool get isEmpty => _events.isEmpty;

  @override
  bool get isNotEmpty => _events.isNotEmpty;

  List<GoalEvent> getGameGoalsEvents(
      {required String idGame, required String idParticipant}) {
    List<GoalEvent> evenement = events
        .whereType<GoalEvent>()
        .where((element) => element.idGame == idGame)
        .toList();
    if (evenement.isEmpty) {
      evenement = [
        GoalEvent(
            idJoueur: 'joueur',
            nom: 'Player',
            idParticipant: idParticipant,
            idGame: idGame,
            idEvent: 'event1'),
        GoalEvent(
            idJoueur: 'joueur',
            nom: 'Player',
            idParticipant: idParticipant,
            idGame: idGame,
            idEvent: 'event2'),
      ];
    }
    return evenement;
  }

  List<CardEvent> getGameCardEvents(
      {required String idGame,
      required String idParticipant,
      bool isRed = false}) {
    List<CardEvent> evenement = events
        .whereType<CardEvent>()
        .where((element) => element.idGame == idGame && element.isRed == isRed)
        .toList();
    if (evenement.isEmpty) {
      evenement = [
        CardEvent(
            isRed: isRed,
            idJoueur: 'joueur',
            nom: 'Player',
            idParticipant: idParticipant,
            idGame: idGame,
            idEvent: 'event1'),
        CardEvent(
            isRed: isRed,
            idJoueur: 'joueur',
            nom: 'Player',
            idParticipant: idParticipant,
            idGame: idGame,
            idEvent: 'event2'),
      ];
    }
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
    if (evenement.isEmpty) {
      evenement = [
        RemplEvent(
            idJoueur: 'joueur',
            nom: 'Player',
            idParticipant: idParticipant,
            idGame: idGame,
            idEvent: 'event1'),
        RemplEvent(
            idJoueur: 'joueur',
            nom: 'Player',
            idParticipant: idParticipant,
            idGame: idGame,
            idEvent: 'event2'),
      ];
    }
    return evenement;
  }
}

class GameEventListSousCollection {
  Game game;
  List<GoalEvent> goals;
  List<CardEvent> redCards;
  List<CardEvent> yellowCards;
  List<RemplEvent> substitutions;

  GameEventListSousCollection({
    required this.game,
    required this.goals,
    required this.redCards,
    required this.yellowCards,
    required this.substitutions,
  });
}
