import 'package:app/models/game.dart';

class GameEvent {
  final Game game;
  EventStream homeEvent;
  EventStream awayEvent;
  TimerEvent? timer;

  GameEvent(
      {required this.game,
      required this.homeEvent,
      required this.awayEvent,
      this.timer});
}

class EventStream {
  String idParticipant;
  int redCard;
  int yellowCard;
  num? pourcent;
  int goal;

  EventStream({
    required this.idParticipant,
    this.redCard = 0,
    this.yellowCard = 0,
    this.goal = 0,
    this.pourcent,
  });
}

class TimerEvent {
  String start;
  int duration;
  int extra;
  int initial;
  int retard;

  TimerEvent({
    required this.start,
    required this.duration,
    required this.extra,
    this.initial = 0,
    this.retard = 0,
  });
}
