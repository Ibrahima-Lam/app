import 'package:app/models/scores/score.dart';

import 'package:app/service/score_service.dart';
import 'package:flutter/material.dart';

class ScoreProvider extends ChangeNotifier {
  List<Score> _scores = [];
  ScoreProvider() {
    getData();
  }

  List<Score> get scores => _scores;
  void set scores(List<Score> val) {
    _scores = val;
    notifyListeners();
  }

  Future<List<Score>> getData() async {
    if (scores.isEmpty) {
      scores = await ScoreService.getData();
    }

    return scores;
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
  }
}
