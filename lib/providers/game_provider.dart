import 'package:app/controllers/game/game_controller.dart';
import 'package:app/core/enums/game_etat_enum.dart';
import 'package:app/core/extension/list_extension.dart';
import 'package:app/models/game.dart';
import 'package:app/models/scores/score.dart';

import 'package:app/service/game_service.dart';
import 'package:app/service/score_service.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  List<Game> _games;
  List<Score> _scores;

  GameProvider(
      [this._games = const [], this._scores = const []]); /* {
    _
  } */
  List<Score> get scores => _scores;
  void set scores(List<Score> val) => _scores = val;

  List<Game> get games => _games;
  void set games(List<Game> val) {
    _games = val.map((element) {
      Score? score =
          scores.singleWhereOrNull((e) => e.idGame == element.idGame);
      if (score != null) element.score = score;
      return element;
    }).toList();

    notifyListeners();
  }

  Future setGames() async {
    games = await GameService().getData;
  }

  Future setScores() async {
    scores = await ScoreService.getData();
  }

  Future<List<Game>> getGames() async {
    if (scores.isEmpty) setScores();
    if (games.isEmpty) await setGames();
    return games;
  }

  Future changeScore(
      {required String idGame, required int? hs, required int? as}) async {
    scores = scores.map((e) {
      if (e.idGame == idGame) {
        e.homeScore = hs;
        e.awayScore = as;
      }
      return e;
    }).toList();
    games = games;
  }

/* 
  Future<GameCollection> getGameEvents() async {
    if (gameEventCollection.isEmpty) {
      gameEventCollection = GameEventCollection([]);
      notifyListeners();
    }
    return gameCollection;
  }

  

  void changeEtat({required String id, required String etat}) async {
    changeEtat(id: id, etat: etat);
    notifyListeners();
  }

  GameEvent getEvent(Game game) {
    if (gameEventCollection.isNotEmpty) {
      final GameEvent? value = gameEventCollection.getElementAt(game.idGame);
      if (value != null) {
        return value;
      }
    }
    EventStream homeEvent = EventStream(
        idParticipant: game.idHome, redCard: 0, yellowCard: 0, pourcent: null);
    EventStream awayEvent = EventStream(
        idParticipant: game.idAway, redCard: 0, yellowCard: 0, pourcent: null);
    GameEvent gameEvent = GameEvent(
        idGame: game.idGame,
        timer: null,
        homeEvent: homeEvent,
        awayEvent: awayEvent);
    gameEventCollection.add(gameEvent);
    return gameEvent;
  } */

  /*  void changePourcent(String id, double? pourcent, {TimerEvent? timerEvent}) {
    gameEventCollection.gameEvents = gameEventCollection.gameEvents.map((e) {
      if (e.idGame == id) {
        pourcent = pourcent == null ? null : (pourcent! * 100).toInt() / 100;
        e.homeEvent.pourcent = pourcent;
        e.awayEvent.pourcent = pourcent == null ? null : 1 - pourcent!;
        e.timer = timerEvent;
      }
      return e;
    }).toList();
    notifyListeners();
  }

  void changeCard(
    String id,
  ) {
    gameEventCollection.gameEvents = gameEventCollection.gameEvents.map((e) {
      if (e.idGame == id) {
        e.awayEvent.redCard = 1;
        e.awayEvent.yellowCard = 5;
        e.homeEvent.yellowCard = 7;
        e.homeEvent.redCard = 2;
      }
      return e;
    }).toList();
    notifyListeners();
  } */

  void sortByDate([bool asc = true]) {
    if (asc) {
      games.sort((a, b) => a.dateGame!.compareTo(b.dateGame!));
    } else
      games.sort((a, b) => a.dateGame!.compareTo(b.dateGame!));
  }

  void changeEtat({required String id, required String etat}) async {
    games = games.map((e) {
      if (e.idGame == id) {
        e.etat = GameEtatClass(etat);
      }
      return e;
    }).toList();
  }

  void changeDate({required String id, required String? date}) async {
    games = games.map((e) {
      if (e.idGame == id) {
        e.dateGame = date;
      }
      return e;
    }).toList();
  }

  void changeHeure({required String id, required String? heure}) async {
    games = games.map((e) {
      if (e.idGame == id) {
        e.heureGame = heure;
      }
      return e;
    }).toList();
  }

  List<Game> get phaseGroupe =>
      games.where((element) => element.codePhase == 'grp').toList();
  List<Game> get phaseEliminatoire =>
      games.where((element) => element.codePhase != 'grp').toList();
  List<Game> get played => games.where((element) => element.isPlayed).toList();
  List<Game> get noPlayed =>
      games.where((element) => !(element.isPlayed)).toList();
  List<Game> get playing => games
      .where((element) =>
          element.etat.etat == GameEtat.direct ||
          element.etat.etat == GameEtat.pause)
      .toList();

  Game getElementAt(String id) {
    return games.singleWhere((element) => element.idGame == id);
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
    String? idParticipant,
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
      idParticipant: idParticipant,
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
