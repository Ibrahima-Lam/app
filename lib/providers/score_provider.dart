import 'package:fscore/core/enums/game_etat_enum.dart';
import 'package:fscore/core/extension/list_extension.dart';
import 'package:fscore/models/gameEvent.dart';
import 'package:fscore/models/scores/score.dart';

import 'package:fscore/service/score_service.dart';
import 'package:flutter/material.dart';

class ScoreProvider extends ChangeNotifier {
  List<Score> _scores;
  ScoreProvider(this._scores);

  List<Score> get scores => _scores;
  void set scores(List<Score> val) {
    _scores = val;
  }

  Stream<List<Score>> ListenData({bool remote = false}) async* {
    yield* ScoreService.listenData();
  }

// Todo: remove this
  Future<List<Score>> getData({bool remote = false}) async {
    return scores;
  }

  Future<List<Score>> initScores() async {
    _scores = await ScoreService.getData();
    return scores;
  }

  Future<bool> addScore(Score score) async {
    final bool result = await ScoreService.addScore(score);
    if (result) await getData(remote: true);
    return result;
  }

  Future<bool> changeEtat(
      {required String idGame, required GameEtatClass etat}) async {
    Score? score =
        scores.singleWhereOrNull((element) => element.idGame == idGame);

    if (score != null) {
      score.etat = etat;
    } else {
      score = Score(idGame: idGame, etat: etat);
    }
    final bool result = await ScoreService.editScore(idGame, score);
    if (result) await getData(remote: true);
    return result;
  }

  Future<bool> editScore(String idGame, Score score) async {
    final bool result = await ScoreService.editScore(idGame, score);
    if (result) await getData(remote: true);
    return result;
  }

  Future<bool> deleteScore(String idGame) async {
    final bool result = await ScoreService.deleteScore(idGame);
    if (result) await getData(remote: true);
    return result;
  }

  Future<bool> changeTimer(
      {required String idGame, required TimerEvent? timer}) async {
    Score? score =
        scores.singleWhereOrNull((element) => element.idGame == idGame);
    if (score != null)
      score.timer = timer;
    else
      score = Score(idGame: idGame, timer: timer);
    final bool result = await ScoreService.editScore(idGame, score);
    if (result) await getData(remote: true);
    return result;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
