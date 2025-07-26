import 'package:fscore/core/enums/game_etat_enum.dart';
import 'package:fscore/models/groupe.dart';
import 'package:fscore/models/niveau.dart';
import 'package:fscore/models/participant.dart';
import 'package:fscore/models/scores/score.dart';
import 'package:fscore/models/searchable.dart';

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
    this.score,
    required this.groupe,
    required this.home,
    required this.away,
    required this.niveau,
  });

  final String versus = 'VS';

  GameEtatClass get etat {
    if (score == null) return GameEtatClass('avant');
    if (score?.etat != null) {
      return score!.etat!;
    }
    if (score?.etat == null && !(score?.isNull ?? true)) {
      return GameEtatClass('termine');
    }
    return GameEtatClass('avant');
  }

  factory Game.fromJson(Map<String, dynamic> json,
      {required Participant home,
      required Participant away,
      required Niveau niveau,
      required Groupe groupe,
      Score? score}) {
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
      score: score,
    );
  }
  bool get noDated {
    if (score?.etat?.etat
        case (GameEtat.annule || GameEtat.arrete || GameEtat.reporte))
      return true;
    return false;
  }

  bool get isPlayed => score?.homeScore != null && score?.awayScore != null;
  bool get isNotPlayed => !isPlayed;
  bool get isPlaying =>
      score?.etat?.etat == GameEtat.direct ||
      score?.etat?.etat == GameEtat.pause;
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
        : heureGame != null && heureGame!.isNotEmpty
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
      "codeNiveau": codeNiveau,
    };
  }
}
