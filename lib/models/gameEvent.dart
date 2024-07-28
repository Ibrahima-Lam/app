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
  String? start;
  int? duration;
  int? extra;
  int? initial;
  int? retard;

  TimerEvent({
    required this.start,
    required this.duration,
    this.extra = 0,
    this.initial = 0,
    this.retard = 0,
  });
  TimerEvent copyWith(
          {String? start,
          int? duration,
          int? extra,
          int? initial,
          int? retard,
          String? etat}) =>
      TimerEvent(
        start: start ?? this.start,
        duration: duration ?? this.duration,
        extra: extra ?? this.extra,
        initial: initial ?? this.initial,
        retard: retard ?? this.retard,
      );
  factory TimerEvent.fromJson(Map<String, dynamic> json) => TimerEvent(
        start: json['start'],
        duration: json['duration'],
        extra: json['extra'],
        retard: json['retard'],
        initial: json['initial'],
      );
  Map<String, dynamic> toJson() => {
        'start': start,
        'duration': duration,
        'extra': extra,
        'retard': retard,
        'initial': initial,
      };
}
