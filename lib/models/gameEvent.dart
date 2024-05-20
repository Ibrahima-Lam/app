class GameEvent {
  final String idGame;
  EventStream homeEvent;
  EventStream awayEvent;
  TimerEvent? timer;

  GameEvent(
      {required this.idGame,
      required this.homeEvent,
      required this.awayEvent,
      this.timer});
}

class EventStream {
  String idPartcipant;
  int redCard;
  int yellowCard;
  double? pourcent;
  int goal;

  EventStream(
      {required this.idPartcipant,
      this.redCard = 0,
      this.yellowCard = 0,
      this.goal = 0,
      this.pourcent});
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
