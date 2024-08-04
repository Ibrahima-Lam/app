import 'package:app/core/enums/game_etat_enum.dart';
import 'package:app/models/gameEvent.dart';
import 'package:app/models/scores/score.dart';
import 'package:app/service/local_service.dart';
import 'package:flutter/material.dart';

class ScoreService {
  static LocalService get service => LocalService('score.json');

  static Future<List<Score>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null) return data.map((e) => Score.fromJson(e)).toList();
    }
    return null;
  }

  static Future<List<Score>> getData({bool remote = false}) async {
    final List<Score> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Score>> getRemoteData() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (scores.isNotEmpty) await service.setData(scores);
      return scores.map((e) => Score.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addScore(Score score) async {
    await Future.delayed(Durations.extralong4);
    if (scores.any((element) => element['idGame'].toString() == score.idGame))
      return false;
    scores.add(score.toJson());
    return true;
  }

  static Future<bool> editScore(String idGame, Score score) async {
    await Future.delayed(Durations.extralong4);
    final index =
        scores.indexWhere((element) => element['idGame'].toString() == idGame);
    if (index == -1) {
      scores.add(score.toJson());
    } else {
      scores[index] = {...scores[index], ...score.toJson()};
    }
    return true;
  }

  static Future<bool> changeEtat(String idGame, GameEtatClass etat) async {
    await Future.delayed(Durations.extralong4);
    final index =
        scores.indexWhere((element) => element['idGame'].toString() == idGame);
    if (index == -1) {
      scores.add({'idGame': idGame, 'etat': etat.text});
    } else {
      scores[index] = {
        ...scores[index],
        ...{'etat': etat.text}
      };
    }
    return true;
  }

  static Future<bool> editScorePenalty(String idGame, Score score) async {
    await Future.delayed(Durations.extralong4);
    final index =
        scores.indexWhere((element) => element['idGame'].toString() == idGame);
    if (index == -1) {
      scores.add(score.toJson());
    } else {
      scores[index] = {...scores[index], ...score.toJson()};
    }
    return true;
  }

  static Future<bool> deleteScore(String idGame) async {
    await Future.delayed(Durations.extralong4);
    final index =
        scores.indexWhere((element) => element['idGame'].toString() == idGame);
    if (index == -1) return false;
    scores.removeAt(index);
    return true;
  }

  static Future<bool> changeTimer(String idGame, TimerEvent? timer) async {
    await Future.delayed(Durations.extralong4);
    final index =
        scores.indexWhere((element) => element['idGame'].toString() == idGame);
    if (index == -1) {
      scores.add(Score(idGame: idGame, timer: timer).toJson());
    } else {
      scores[index] = {...scores[index], ...timer?.toJson() ?? {}};
    }
    return true;
  }
}

List<Map<String, dynamic>> scores = [
  /*  {
    "idGame": 67,
    "homeScore": 2,
    "awayScore": 2,
    "homeScorePenalty": null,
    "awayScorePenalty": null
  }, */
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
