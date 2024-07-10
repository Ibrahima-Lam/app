class Score {
  String idGame;
  String? etat;
  int? homeScore;
  int? awayScore;
  int? homeScorePenalty;
  int? awayScorePenalty;
  String? start;
  int? duration;
  int? extra;
  int? initial;
  int? retard;
  Score({
    required this.idGame,
    this.etat,
    this.homeScore,
    this.awayScore,
    this.homeScorePenalty,
    this.awayScorePenalty,
    this.start,
    this.duration,
    this.extra = 0,
    this.initial = 0,
    this.retard = 0,
  });
  factory Score.fromJson(Map<String, dynamic> json) => Score(
        idGame: json['idGame'].toString(),
        etat: json['etat'],
        homeScore: json['homeScore'],
        awayScore: json['awayScore'],
        homeScorePenalty: json['homeScorePenalty'],
        awayScorePenalty: json['awayScorePenalty'],
        start: json['start'],
        duration: json['duration'],
        extra: json['extra'],
        initial: json['initial'],
        retard: json['retard'],
      );
}
