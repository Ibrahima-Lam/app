import 'package:app/models/coachs/coach.dart';
import 'package:app/service/coach_service.dart';
import 'package:flutter/material.dart';

class CoachProvider extends ChangeNotifier {
  var _coachs = <Coach>[];

  List<Coach> get coachs => _coachs
      .where((element) => element.role.toUpperCase() == "COACH")
      .toList();
  List<Coach> get entraineurs => _coachs;
  void set coachs(List<Coach> val) {
    _coachs = val;
    notifyListeners();
  }

  Future<List<Coach>> getData({bool remote = false}) async {
    if (_coachs.isEmpty || remote) {
      coachs = await CoachService.getData(remote: remote);
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

  Future<bool> addCoach(Coach coach) async {
    final bool result = await CoachService.addCoach(coach);
    if (result) await getData(remote: true);
    return result;
  }

  Future<bool> editCoach(String idCoach, Coach coach) async {
    final bool result = await CoachService.editCoach(idCoach, coach);
    if (result) await getData(remote: true);
    return result;
  }

  Future<bool> deleteCoach(String idCoach) async {
    final bool result = await CoachService.deleteCoach(idCoach);
    if (result) await getData(remote: true);
    return result;
  }
}
