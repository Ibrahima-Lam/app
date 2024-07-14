import 'package:app/core/enums/game_etat_enum.dart';
import 'package:app/models/groupe.dart';
import 'package:app/models/niveau.dart';
import 'package:app/models/participant.dart';
import 'package:app/models/scores/score.dart';
import 'package:app/models/searchable.dart';

class Game implements Searchable {
  String idGame;
  String idHome;

  String idAway;
  String? dateGame;
  String? stadeGame;
  String? heureGame;
  String? idGroupe;

  Participant home;
  Participant away;

  String? codeNiveau;

  GameEtatClass etat;
  Score? score;
  Niveau niveau;
  Groupe groupe;

  Game({
    required this.idGame,
    required this.idHome,
    required this.idAway,
    this.dateGame,
    this.stadeGame,
    this.heureGame,
    this.idGroupe,
    this.codeNiveau,
    this.etat = const GameEtatClass('termine'),
    this.score,
    required this.groupe,
    required this.home,
    required this.away,
    required this.niveau,
  });

  final String versus = 'VS';

  factory Game.fromJson(Map<String, dynamic> json,
      {required Participant home,
      required Participant away,
      required Niveau niveau,
      required Groupe groupe}) {
    return Game(
      idGame: json["idGame"].toString(),
      idHome: json["idHome"],
      idAway: json["idAway"],
      dateGame: json["dateGame"],
      stadeGame: json["stadeGame"],
      heureGame: json["heureGame"],
      idGroupe: json["idGroupe"].toString(),
      codeNiveau: json["codeNiveau"],
      home: home,
      away: away,
      niveau: niveau,
      groupe: groupe,
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
      "codeNiveau": codeNiveau,
    };
  }
}
