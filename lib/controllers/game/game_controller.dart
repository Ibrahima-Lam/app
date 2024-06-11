import 'package:app/models/game.dart';

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
}
