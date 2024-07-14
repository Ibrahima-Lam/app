import 'package:app/models/scores/score.dart';
import 'package:flutter/material.dart';

class ScoreService {
  static Future<List<Score>> getData() async {
    await Future.delayed(Durations.extralong4);
    return scores.map((e) => Score.fromJson(e)).toList();
  }

  static Stream<Score> getScores() async* {
    List<Score> scores = await Future.delayed(Durations.extralong4);
    for (var score in scores) {
      yield score;
    }
    ;
  }
}

List<Map<String, dynamic>> scores = [
  {
    "idGame": 45,
    "homeScore": 0,
    "awayScore": 1,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 1,
    "homeScore": 2,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 3,
    "homeScore": 2,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 46,
    "homeScore": 2,
    "awayScore": 1,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 47,
    "homeScore": 1,
    "awayScore": 3,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 4,
    "homeScore": 0,
    "awayScore": 1,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 32,
    "homeScore": 0,
    "awayScore": 3,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 49,
    "homeScore": 0,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 50,
    "homeScore": 0,
    "awayScore": 2,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 51,
    "homeScore": 2,
    "awayScore": 3,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 52,
    "homeScore": 3,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 48,
    "homeScore": 1,
    "awayScore": 6,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 53,
    "homeScore": 0,
    "awayScore": 1,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 33,
    "homeScore": 0,
    "awayScore": 7,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 54,
    "homeScore": 3,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 34,
    "homeScore": 4,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 55,
    "homeScore": 1,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 43,
    "homeScore": 3,
    "awayScore": 1,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 36,
    "homeScore": 3,
    "awayScore": 2,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 56,
    "homeScore": 1,
    "awayScore": 2,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 71,
    "homeScore": 3,
    "awayScore": 2,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 57,
    "homeScore": 0,
    "awayScore": 1,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 58,
    "homeScore": 2,
    "awayScore": 1,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 59,
    "homeScore": 3,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 37,
    "homeScore": 1,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 39,
    "homeScore": 0,
    "awayScore": 3,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 60,
    "homeScore": 1,
    "awayScore": 1,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 61,
    "homeScore": 2,
    "awayScore": 2,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 62,
    "homeScore": 2,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 38,
    "homeScore": 0,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 64,
    "homeScore": 0,
    "awayScore": 2,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 72,
    "homeScore": 0,
    "awayScore": 1,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 65,
    "homeScore": 0,
    "awayScore": 3,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 66,
    "homeScore": 0,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 68,
    "homeScore": 1,
    "awayScore": 2,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 69,
    "homeScore": 0,
    "awayScore": 1,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 70,
    "homeScore": 2,
    "awayScore": 1,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 40,
    "homeScore": 6,
    "awayScore": 1,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 35,
    "homeScore": 2,
    "awayScore": 2,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 41,
    "homeScore": 1,
    "awayScore": 4,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 42,
    "homeScore": 1,
    "awayScore": 2,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 77,
    "homeScore": 0,
    "awayScore": 2,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 73,
    "homeScore": 0,
    "awayScore": 0,
    "homeScorePenalty": 4,
    "awayScorePenalty": 6
  },
  {
    "idGame": 74,
    "homeScore": 1,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 75,
    "homeScore": 1,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 76,
    "homeScore": 0,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 44,
    "homeScore": 3,
    "awayScore": 1,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 78,
    "homeScore": 1,
    "awayScore": 1,
    "homeScorePenalty": 5,
    "awayScorePenalty": 6
  },
  {
    "idGame": 79,
    "homeScore": 2,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 80,
    "homeScore": 0,
    "awayScore": 3,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  },
  {
    "idGame": 89,
    "homeScore": 1,
    "awayScore": 0,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  }
];
