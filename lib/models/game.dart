import 'package:app/core/enums/game_etat_enum.dart';
import 'package:app/models/scores/score.dart';
import 'package:app/models/searchable.dart';

class Game implements Searchable {
  String idGame;
  String idHome;
  String? homeImage;
  String? awayImage;
  String idAway;
  String? dateGame;
  String? stadeGame;
  String? heureGame;
  String? idGroupe;
  String? home;
  String? away;

  String? nomGroupe;
  String codeEdition;
  String? anneeEdition;
  String? codePhase;
  String? codeNiveau;
  String? nomNiveau;
  String? nomPhase;
  String? typePhase;
  int? homeScorePenalty;
  int? awayScorePenalty;
  GameEtatClass etat;
  String nomCompetition;
  Score? score;

  Game({
    required this.idGame,
    required this.idHome,
    required this.idAway,
    this.dateGame,
    this.stadeGame,
    this.heureGame,
    this.idGroupe,
    this.home,
    this.away,
    this.homeImage,
    this.awayImage,
    this.nomGroupe,
    required this.codeEdition,
    this.anneeEdition,
    this.codePhase,
    this.codeNiveau,
    this.nomNiveau,
    this.nomPhase,
    this.typePhase,
    this.etat = const GameEtatClass('termine'),
    this.nomCompetition = '',
    this.score,
  });

  final String versus = 'VS';

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      idGame: json["idGame"].toString(),
      idHome: json["idHome"],
      idAway: json["idAway"],
      dateGame: json["dateGame"],
      stadeGame: json["stadeGame"],
      heureGame: json["heureGame"],
      idGroupe: json["idGroupe"].toString(),
      home: json["home"],
      away: json["away"],
      nomGroupe: json["nomGroupe"],
      codeEdition: json["codeEdition"],
      anneeEdition: json["anneeEdition"],
      codePhase: json["codePhase"],
      codeNiveau: json["codeNiveau"],
      nomNiveau: json["nomNiveau"],
      nomPhase: json["nomPhase"],
      typePhase: json["typePhase"],
    );
  }

  bool get isPlayed => score?.homeScore != null && score?.awayScore != null;
  bool get isNotPlayed => !isPlayed;
  bool get isPlaying =>
      etat.etat == GameEtat.direct || etat.etat == GameEtat.pause;
  bool get hasTiraubut =>
      score?.homeScorePenalty != null && score?.awayScorePenalty != null;
  bool get isHomeVictoire =>
      isPlayed ? (score?.homeScore ?? 0) > (score?.awayScore ?? 0) : false;
  bool get isAwayVictoire =>
      isPlayed ? (score?.homeScore ?? 0) < (score?.awayScore ?? 0) : false;

  String get scoreText {
    final String scoreText = isPlayed
        ? (hasTiraubut
            ? '(${score?.homeScorePenalty})  ${score?.homeScore}-${score?.awayScore}  (${score?.awayScorePenalty})'
            : '${score?.homeScore}-${score?.awayScore}')
        : heureGame != null
            ? heureGame!
            : versus;
    return scoreText;
  }

  Map<String, dynamic> toJson() {
    return {
      "idGame": idGame,
      "idHome": idHome,
      "idAway": idAway,
      "dateGame": dateGame,
      "stadeGame": stadeGame,
      "heureGame": heureGame,
      "idGroupe": idGroupe,
      "home": home,
      "away": away,
      "nomGroupe": nomGroupe,
      "codeEdition": codeEdition,
      "anneeEdition": anneeEdition,
      "codePhase": codePhase,
      "codeNiveau": codeNiveau,
      "nomNiveau": nomNiveau,
      "nomPhase": nomPhase,
      "typePhase": typePhase,
      "homeScorePenalty": homeScorePenalty,
      "awayScorePenalty": awayScorePenalty,
    };
  }
}
