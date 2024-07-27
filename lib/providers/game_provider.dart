import 'package:app/controllers/game/game_controller.dart';
import 'package:app/core/enums/game_etat_enum.dart';
import 'package:app/core/extension/list_extension.dart';
import 'package:app/models/game.dart';
import 'package:app/models/gameEvent.dart';
import 'package:app/models/niveau.dart';
import 'package:app/models/scores/score.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/providers/groupe_provider.dart';
import 'package:app/providers/participant_provider.dart';

import 'package:app/service/game_service.dart';
import 'package:app/service/score_service.dart';
import 'package:flutter/material.dart';

typedef GameList = List<Game>;

class GameProvider extends ChangeNotifier {
  GameList _games;
  List<Score> _scores;

  GameEventListProvider gameEventListProvider;
  ParticipantProvider participantProvider;
  GroupeProvider groupeProvider;

  GameProvider(
    this._games,
    this._scores, {
    required this.participantProvider,
    required this.gameEventListProvider,
    required this.groupeProvider,
  }); /* {
    _
  } */
  List<Score> get scores => _scores;
  void set scores(List<Score> val) => _scores = val;

  GameList get games => _games;
  void set games(GameList val) {
    _games = val.map((element) {
      Score? score =
          scores.singleWhereOrNull((e) => e.idGame == element.idGame);
      if (score != null) element.score = score;
      return element;
    }).toList();
    _games.sort(
      (a, b) {
        if ((a.dateGame ?? '').compareTo(b.dateGame ?? '') != 0)
          return (a.dateGame ?? '').compareTo(b.dateGame ?? '');
        return (a.heureGame ?? '').compareTo(b.heureGame ?? '');
      },
    );

    notifyListeners();
  }

  Future setGames({bool remote = false}) async {
    games = await GameService().getData(
        participantProvider.participants, groupeProvider.groupes,
        remote: remote);
  }

  Future setScores() async {
    scores = await ScoreService.getData();
  }

  Future<GameList> getGames({bool remote = false}) async {
    if (groupeProvider.groupes.isEmpty || remote)
      await groupeProvider.initGroupes();
    if (participantProvider.participants.isEmpty || remote)
      await participantProvider.initParticipants();
    if (scores.isEmpty || remote) setScores();
    if (games.isEmpty || remote) await setGames(remote: remote);
    return games;
  }

  Future<bool> addGame(Game game) async {
    bool res = await GameService().addGame(game);
    if (res) await getGames(remote: true);
    return res;
  }

  Future<bool> removeGame(String idGame) async {
    bool res = await GameService().removeGame(idGame);
    if (res) await getGames(remote: true);
    return res;
  }

  Future<bool> editGame(String idGame, Game game) async {
    bool res = await GameService().editGame(idGame, game);
    if (res) await getGames(remote: true);
    return res;
  }

  Future changeScore(
      {required String idGame, required int? hs, required int? as}) async {
    Score? score = scores.singleWhereOrNull((e) => e.idGame == idGame);
    final bool check = score != null;
    if (!check) {
      score = Score(idGame: idGame, homeScore: hs, awayScore: as);
    } else {
      score.homeScore = hs;
      score.awayScore = as;
    }
    if (!check) {
      scores.add(score);
    }

    games = games;
  }

  Future changeTimer(
      {required String idGame, required TimerEvent? timer}) async {
    Score? score = scores.singleWhereOrNull((e) => e.idGame == idGame);
    final bool check = score != null;
    if (!check) {
      score = Score(idGame: idGame, timer: timer);
    } else {
      score.timer = timer;
    }
    if (!check) {
      scores.add(score);
    }

    games = games;
  }

  Future changeNiveau({required String idGame, required Niveau niveau}) async {
    games = games.map((e) {
      if (e.idGame == idGame) {
        e.niveau = niveau;
      }
      return e;
    }).toList();
  }

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

  GameList get phaseGroupe =>
      games.where((element) => element.niveau.codeNiveau == 'grp').toList();
  GameList get phaseEliminatoire =>
      games.where((element) => element.niveau.codeNiveau != 'grp').toList();
  GameList get played => games.where((element) => element.isPlayed).toList();
  GameList get noPlayed =>
      games.where((element) => !(element.isPlayed)).toList();
  GameList get playing => games
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
    GameList gamesData = GameController().filterGamesBy(
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

  GameList getGamesBy({
    String? idGroupe,
    String? idParticipant,
    String? codeNiveau,
    String? codeEdition,
    String? dateGame,
    bool playing = false,
    bool? played,
    bool? noPlayed,
  }) {
    GameList gamesData = GameController().filterGamesBy(
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
