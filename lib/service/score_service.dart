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
  {"idGame": 45, "homeScore": 0, "awayScore": 1},
  {"idGame": 1, "homeScore": 2, "awayScore": 0},
  {"idGame": 3, "homeScore": 2, "awayScore": 0},
  {"idGame": 46, "homeScore": 2, "awayScore": 1},
  {"idGame": 47, "homeScore": 1, "awayScore": 3},
  {"idGame": 4, "homeScore": 0, "awayScore": 1},
  {"idGame": 32, "homeScore": 0, "awayScore": 3},
  {"idGame": 49, "homeScore": 0, "awayScore": 0},
  {"idGame": 50, "homeScore": 0, "awayScore": 2},
  {"idGame": 51, "homeScore": 2, "awayScore": 3},
  {"idGame": 52, "homeScore": 3, "awayScore": 0},
  {"idGame": 48, "homeScore": 1, "awayScore": 6},
  {"idGame": 53, "homeScore": 0, "awayScore": 1},
  {"idGame": 33, "homeScore": 0, "awayScore": 7},
  {"idGame": 54, "homeScore": 3, "awayScore": 0},
  {"idGame": 34, "homeScore": 4, "awayScore": 0},
  {"idGame": 55, "homeScore": 1, "awayScore": 0},
  {"idGame": 43, "homeScore": 3, "awayScore": 1},
  {"idGame": 36, "homeScore": 3, "awayScore": 2},
  {"idGame": 56, "homeScore": 1, "awayScore": 2},
  {"idGame": 71, "homeScore": 3, "awayScore": 2},
  {"idGame": 57, "homeScore": 0, "awayScore": 1},
  {"idGame": 58, "homeScore": 2, "awayScore": 1},
  {"idGame": 59, "homeScore": 3, "awayScore": 0},
  {"idGame": 37, "homeScore": 1, "awayScore": 0},
  {"idGame": 39, "homeScore": 0, "awayScore": 3},
  {"idGame": 60, "homeScore": 1, "awayScore": 1},
  {"idGame": 61, "homeScore": 2, "awayScore": 2},
  {"idGame": 62, "homeScore": 2, "awayScore": 0},
  {"idGame": 38, "homeScore": 0, "awayScore": 0},
  {"idGame": 64, "homeScore": 0, "awayScore": 2},
  {"idGame": 72, "homeScore": 0, "awayScore": 1},
  {"idGame": 65, "homeScore": 0, "awayScore": 3},
  {"idGame": 66, "homeScore": 0, "awayScore": 0},
  {"idGame": 68, "homeScore": 1, "awayScore": 2},
  {"idGame": 69, "homeScore": 0, "awayScore": 1},
  {"idGame": 70, "homeScore": 2, "awayScore": 1},
  {"idGame": 40, "homeScore": 6, "awayScore": 1},
  {"idGame": 35, "homeScore": 2, "awayScore": 2},
  {"idGame": 41, "homeScore": 1, "awayScore": 4},
  {"idGame": 42, "homeScore": 1, "awayScore": 2},
  {"idGame": 77, "homeScore": 0, "awayScore": 2},
  {"idGame": 73, "homeScore": 0, "awayScore": 0},
  {"idGame": 74, "homeScore": 1, "awayScore": 0},
  {"idGame": 75, "homeScore": 1, "awayScore": 0},
  {"idGame": 76, "homeScore": 0, "awayScore": 0},
  {"idGame": 44, "homeScore": 3, "awayScore": 1},
  {"idGame": 78, "homeScore": 1, "awayScore": 1},
  {"idGame": 79, "homeScore": 2, "awayScore": 0},
  {"idGame": 80, "homeScore": 0, "awayScore": 3},
  {"idGame": 89, "homeScore": 1, "awayScore": 0}
];
