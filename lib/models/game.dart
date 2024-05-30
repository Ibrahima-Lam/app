import 'package:app/core/enums/game_etat_enum.dart';
import 'package:app/models/searchable.dart';

class Game implements Searchable {
  String idGame;
  String idHome;
  String idAway;
  String? dateGame;
  String? stadeGame;
  String? heureGame;
  String? idGroupe;
  String? home;
  String? away;
  int? homeScore;
  int? awayScore;
  String? nomGroupe;
  String? codeEdition;
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
    this.homeScore,
    this.awayScore,
    this.nomGroupe,
    this.codeEdition,
    this.anneeEdition,
    this.codePhase,
    this.codeNiveau,
    this.nomNiveau,
    this.nomPhase,
    this.typePhase,
    this.homeScorePenalty,
    this.awayScorePenalty,
    this.etat = const GameEtatClass('termine'),
    this.nomCompetition = '',
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
      homeScore: json["homeScore"],
      awayScore: json["awayScore"],
      nomGroupe: json["nomGroupe"],
      codeEdition: json["codeEdition"],
      anneeEdition: json["anneeEdition"],
      codePhase: json["codePhase"],
      codeNiveau: json["codeNiveau"],
      nomNiveau: json["nomNiveau"],
      nomPhase: json["nomPhase"],
      typePhase: json["typePhase"],
      homeScorePenalty: json["homeScorePenalty"],
      awayScorePenalty: json["awayScorePenalty"],
    );
  }

  bool get isPlayed => homeScore != null && awayScore != null;
  bool get isNotPlayed => !isPlayed;
  bool get isPlaying =>
      etat.etat == GameEtat.direct || etat.etat == GameEtat.pause;
  bool get hasTiraubut => homeScorePenalty != null && awayScorePenalty != null;
  bool get isHomeVictoire => isPlayed ? homeScore! > awayScore! : false;
  bool get isAwayVictoire => isPlayed ? homeScore! < awayScore! : false;

  String get score {
    final String score = isPlayed
        ? (hasTiraubut
            ? '(${homeScorePenalty})  ${homeScore}-${awayScore}  (${awayScorePenalty})'
            : '${homeScore}-${awayScore}')
        : heureGame != null
            ? heureGame!
            : versus;
    return score;
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
      "homeScore": homeScore,
      "awayScore": awayScore,
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
