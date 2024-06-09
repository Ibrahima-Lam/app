import 'package:app/collection/collection.dart';
import 'package:app/controllers/game/game_controller.dart';
import 'package:app/core/enums/game_etat_enum.dart';
import 'package:app/models/game.dart';

class GameCollection implements Collection {
  List<Game> _games;
  GameCollection(this._games);

  bool get isEmpty => _games.isEmpty;
  bool get isNotEmpty => _games.isNotEmpty;
  List<Game> get games => _games;
  void set games(List<Game> val) => _games = val;

  void sortByDate([bool asc = true]) {
    if (asc) {
      _games.sort((a, b) => a.dateGame!.compareTo(b.dateGame!));
    } else
      _games.sort((a, b) => a.dateGame!.compareTo(b.dateGame!));
  }

  void changeEtat({required String id, required String etat}) async {
    _games = games.map((e) {
      if (e.idGame == id) {
        e.etat = GameEtatClass(etat);
      }
      return e;
    }).toList();
  }

  void changeScore(
      {required String id,
      required int homeScore,
      required int awayScore}) async {
    games = games.map((e) {
      if (e.idGame == id) {
        e.homeScore = homeScore;
        e.awayScore = awayScore;
      }
      return e;
    }).toList();
  }

  List<Game> get phaseGroupe =>
      _games.where((element) => element.codePhase == 'grp').toList();
  List<Game> get phaseEliminatoire =>
      _games.where((element) => element.codePhase != 'grp').toList();
  List<Game> get played => _games.where((element) => element.isPlayed).toList();
  List<Game> get noPlayed =>
      _games.where((element) => !(element.isPlayed)).toList();
  List<Game> get playing => _games
      .where((element) =>
          element.etat.etat == GameEtat.direct ||
          element.etat.etat == GameEtat.pause)
      .toList();

  Game getElementAt(String id) {
    return _games.where((element) => element.idGame == id).toList()[0];
  }

  void filterGamesBy({
    String? idGroupe,
    String? codeNiveau,
    String? codeEdition,
    String? dateGame,
    bool playing = false,
    bool? played,
    bool? noPlayed,
  }) {
    List<Game> gamesData = GameController().filterGamesBy(
      games,
      idGroupe: idGroupe,
      codeNiveau: codeNiveau,
      codeEdition: codeEdition,
      dateGame: dateGame,
      playing: playing,
      played: played,
      noPlayed: noPlayed,
    );
    games = gamesData;
  }

  List<Game> getGamesBy({
    String? idGroupe,
    String? idPartcipant,
    String? codeNiveau,
    String? codeEdition,
    String? dateGame,
    bool playing = false,
    bool? played,
    bool? noPlayed,
  }) {
    List<Game> gamesData = GameController().filterGamesBy(
      games,
      idGroupe: idGroupe,
      idPartcipant: idPartcipant,
      codeNiveau: codeNiveau,
      codeEdition: codeEdition,
      dateGame: dateGame,
      playing: playing,
      played: played,
      noPlayed: noPlayed,
    );

    return gamesData;
  }
}
