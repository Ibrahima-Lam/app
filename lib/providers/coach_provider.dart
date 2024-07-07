import 'package:app/models/coachs/coach.dart';
import 'package:app/service/coach_service.dart';
import 'package:flutter/material.dart';

class CoachProvider extends ChangeNotifier {
  var _coachs = <Coach>[];

  List<Coach> get coachs => _coachs
      .where((element) => element.role.toUpperCase() == "COACH")
      .toList();
  List<Coach> get entraineurs => _coachs;
  void set coachs(List<Coach> val) => _coachs = val;

  Future<List<Coach>> getData() async {
    if (_coachs.isEmpty) {
      await Future.delayed(Durations.extralong4);
      coachs = CoachService.getCoachs();
    }
    return coachs;
  }

  Coach? getCoach(String id) {
    try {
      return coachs.singleWhere((element) => element.idCoach == id);
    } catch (e) {
      return null;
    }
  }

  Coach? getCoachByEquipe(String idParticipant) {
    try {
      return coachs
          .lastWhere((element) => element.idParticipant == idParticipant);
    } catch (e) {
      return null;
    }
  }
}
