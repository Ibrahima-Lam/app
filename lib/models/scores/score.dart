import 'package:app/core/enums/game_etat_enum.dart';
import 'package:app/models/gameEvent.dart';

class Score {
  String idGame;
  int? homeScore;
  int? awayScore;
  int? homeScorePenalty;
  int? awayScorePenalty;
  TimerEvent? timer;
  GameEtatClass? etat;
  String? datetime;
  Score({
    required this.idGame,
    this.homeScore,
    this.awayScore,
    this.homeScorePenalty,
    this.awayScorePenalty,
    this.timer,
    this.etat,
    this.datetime,
  });
  bool get isPenalty => homeScorePenalty != null && awayScorePenalty != null;
  bool get isScore => homeScore != null && awayScore != null;
  bool get isNull =>
      homeScore == null &&
      awayScore == null &&
      homeScorePenalty == null &&
      awayScorePenalty == null;

  Score copyWith({
    String? idGame,
    int? homeScore,
    int? awayScore,
    int? homeScorePenalty,
    int? awayScorePenalty,
    TimerEvent? timer,
    GameEtatClass? etat,
    String? datetime,
  }) =>
      Score(
        idGame: idGame ?? this.idGame,
        homeScore: homeScore ?? this.homeScore,
        awayScore: awayScore ?? this.awayScore,
        homeScorePenalty: homeScorePenalty ?? this.homeScorePenalty,
        awayScorePenalty: awayScorePenalty ?? this.awayScorePenalty,
        timer: timer ?? this.timer,
        etat: etat ?? this.etat,
        datetime: datetime ?? this.datetime,
      );

  factory Score.fromJson(Map<String, dynamic> json) => Score(
      idGame: json['idGame'].toString(),
      homeScore: json['homeScore'],
      awayScore: json['awayScore'],
      homeScorePenalty: json['homeScorePenalty'],
      awayScorePenalty: json['awayScorePenalty'],
      datetime: json['datetime'],
      etat: json['etat'] == null ? null : GameEtatClass(json['etat']),
      timer: TimerEvent.fromJson({
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
        "etat": etat?.text,
        "datetime": datetime,
        ...timer?.toJson() ?? {},
      };
}
