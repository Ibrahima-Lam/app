import 'package:app/core/enums/game_etat_enum.dart';
import 'package:app/core/extension/list_extension.dart';
import 'package:app/models/gameEvent.dart';
import 'package:app/models/scores/score.dart';

import 'package:app/service/score_service.dart';
import 'package:flutter/material.dart';

class ScoreProvider extends ChangeNotifier {
  List<Score> _scores;
  ScoreProvider(this._scores);

  List<Score> get scores => _scores;
  void set scores(List<Score> val) {
    _scores = val;
    notifyListeners();
  }

  Future<List<Score>> getData({bool remote = false}) async {
    if (scores.isEmpty || remote) {
      scores = await ScoreService.getData(remote: remote);
    }
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
    if (score != null)
      score.etat = etat;
    else
      score = Score(idGame: idGame, etat: etat);
    final bool result = await await ScoreService.editScore(idGame, score);
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
    final bool result = await await ScoreService.editScore(idGame, score);
    if (result) await getData(remote: true);
    return result;
  }
}
