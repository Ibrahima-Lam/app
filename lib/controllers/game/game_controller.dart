import 'package:app/models/game.dart';
import 'package:app/models/groupe.dart';
import 'package:app/models/niveau.dart';
import 'package:app/models/participant.dart';

class GameController {
  List<Game> filterGamesBy(
    List<Game> games, {
    String? idGroupe,
    String? idParticipant,
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
    if (idParticipant != null) {
      games = games
          .where((element) =>
              element.idHome == idParticipant ||
              element.idAway == idParticipant)
          .toList();
    }
    if (codeNiveau != null) {
      games =
          games.where((element) => element.codeNiveau == codeNiveau).toList();
    }
    if (codeEdition != null) {
      games = games
          .where((element) => element.groupe.codeEdition == codeEdition)
          .toList();
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

  static Game? toGame(
      {required String idGame,
      required String idHome,
      required String idAway,
      required String idGroupe,
      required String codeNiveau,
      String? dateGame,
      String? heureGame,
      String? stadeGame,
      required List<Niveau> niveaux,
      required List<Groupe> groupes,
      required List<Participant> participants}) {
    if ((!participants.any((e) => e.idParticipant == idHome) &&
        participants.any((e) => e.idParticipant == idAway) &&
        groupes.any((e) => e.idGroupe == idGroupe))) return null;
    Participant home =
        participants.lastWhere((element) => element.idParticipant == idHome);
    Participant away =
        participants.lastWhere((element) => element.idParticipant == idAway);
    Niveau niveau = niveaux.singleWhere(
      (element) => element.codeNiveau == codeNiveau,
      orElse: () => Niveau(
          codeNiveau: '', nomNiveau: '', typeNiveau: '', ordreNiveau: ''),
    );
    Groupe groupe =
        groupes.singleWhere((element) => idGroupe == element.idGroupe);
    return Game(
        idGame: idGame,
        idHome: idHome,
        idAway: idAway,
        idGroupe: idGroupe,
        codeNiveau: codeNiveau,
        dateGame: dateGame,
        heureGame: heureGame,
        stadeGame: stadeGame,
        groupe: groupe,
        home: home,
        away: away,
        niveau: niveau);
  }
}
