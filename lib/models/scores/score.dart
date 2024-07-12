import 'package:app/models/gameEvent.dart';

class Score {
  String idGame;
  int? homeScore;
  int? awayScore;
  int? homeScorePenalty;
  int? awayScorePenalty;
  TimerEvent? timer;
  Score({
    required this.idGame,
    this.homeScore,
    this.awayScore,
    this.homeScorePenalty,
    this.awayScorePenalty,
    this.timer,
  });
  factory Score.fromJson(Map<String, dynamic> json) => Score(
      idGame: json['idGame'].toString(),
      homeScore: json['homeScore'],
      awayScore: json['awayScore'],
      homeScorePenalty: json['homeScorePenalty'],
      awayScorePenalty: json['awayScorePenalty'],
      timer: TimerEvent.fromJson({
        "etat": json['etat'],
        "start": json['start'],
        "duration": json['duration'],
        "extra": json['extra'],
        "initial": json['initial'],
        "retard": json['retard'],
      }));

  Map<String, dynamic> toJson() => {
        "idGame": idGame,
        "homeScore": homeScore,
        "awayScore": awayScore,
        "homeScorePenalty": homeScorePenalty,
        "awayScorePenalty": awayScorePenalty,
        "timer": timer!.toJson()
      };
}
