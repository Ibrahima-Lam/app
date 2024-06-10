import 'package:app/core/enums/performance_type.dart';
import 'package:app/models/composition.dart';
import 'package:app/models/event.dart';
import 'package:app/models/game.dart';
import 'package:app/models/joueur.dart';
import 'package:app/models/performance.dart';

class GameController {
  List<Game> filterGamesBy(
    List<Game> games, {
    String? idGroupe,
    String? idPartcipant,
    String? codeNiveau,
    String? codeEdition,
    String? dateGame,
    bool playing = false,
    bool? played,
    bool? noPlayed,
  }) {
    if (idGroupe != null) {
      games = games.where((element) => element.idGroupe == idGroupe).toList();
    }
    if (idPartcipant != null) {
      games = games
          .where((element) =>
              element.idHome == idPartcipant || element.idAway == idPartcipant)
          .toList();
    }
    if (codeNiveau != null) {
      games =
          games.where((element) => element.codeNiveau == codeNiveau).toList();
    }
    if (codeEdition != null) {
      games =
          games.where((element) => element.codeEdition == codeEdition).toList();
    }
    if (dateGame != null) {
      games = games.where((element) => element.dateGame == dateGame).toList();
    }
    if (playing) {
      games = games.where((element) => element.isPlaying).toList();
    }
    if (played != null) {
      games = games.where((element) => element.isPlayed).toList();
    }
    if (noPlayed != null) {
      games = games.where((element) => element.isNotPlayed).toList();
    }
    return games;
  }

  static List<Game> getJoueurConvocation(
    String idJoueur, {
    required List<JoueurComposition> compositions,
    required List<Game> games,
  }) {
    List<JoueurComposition> compos =
        compositions.where((element) => element.idJoueur == idJoueur).toList();
    return games
        .where((element) => compos.any((e) => e.idGame == element.idGame))
        .toList();
  }

  static List<GamePerformances> getJoueurPerformance(
    Joueur joueur, {
    required List<Game> games,
    required List<Event> events,
  }) {
    events = events
        .whereType<GoalEvent>()
        .where((element) =>
            element.idJoueur == joueur.idJoueur ||
            element.idTarget == joueur.idJoueur)
        .toList();
    games = games
        .where((element) => events.any((e) => e.idGame == element.idGame))
        .toList();
    List<GamePerformances> performances = [];
    for (Game game in games) {
      int but = events.fold(
          0,
          (previousValue, element) =>
              previousValue +
              (element.idGame == game.idGame &&
                      element.idJoueur == joueur.idJoueur
                  ? 1
                  : 0));
      int passe = events.fold(
          0,
          (previousValue, element) =>
              previousValue +
              (element.idGame == game.idGame &&
                      element.idTarget == joueur.idJoueur
                  ? 1
                  : 0));
      performances.add(GamePerformances(game: game, performances: [
        if (but > 0)
          Performance(
            id: joueur.idJoueur,
            nom: joueur.nomJoueur,
            type: PerformanceType.but,
            nombre: but,
          ),
        if (passe > 0)
          Performance(
            id: joueur.idJoueur,
            nom: joueur.nomJoueur,
            type: PerformanceType.passe,
            nombre: passe,
          )
      ]));
    }

    return performances;
  }
}
