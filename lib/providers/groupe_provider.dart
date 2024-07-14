import 'package:app/core/enums/competition_phase_enum.dart';
import 'package:app/models/groupe.dart';
import 'package:app/service/groupe_service.dart';
import 'package:flutter/material.dart';

class GroupeProvider extends ChangeNotifier {
  List<Groupe> _groupes;

  GroupeProvider([this._groupes = const []]);

  Future<List<Groupe>> getGroupes() async {
    if (groupes.isEmpty) {
      groupes = (await GroupeService.getData());
      notifyListeners();
    }
    return groupes;
  }

  Future<List<Groupe>> initGroupes() async {
    if (groupes.isEmpty) {
      groupes = (await GroupeService.getData());
    }
    return groupes;
  }

  List<Groupe> get groupes => _groupes;
  void set groupes(List<Groupe> val) => _groupes = val;

  List<Groupe> get phaseGroupe =>
      _groupes.where((element) => element.codePhase == 'grp').toList();
  List<Groupe> get phaseEliminatoire =>
      _groupes.where((element) => element.codePhase != 'grp').toList();

  void sortById([bool asc = true]) {
    if (asc) {
      _groupes.sort((a, b) => a.idGroupe.compareTo(b.idGroupe));
    } else
      _groupes.sort((a, b) => a.idGroupe.compareTo(b.idGroupe));
  }

  Groupe getElementAt(String id) {
    return _groupes.where((element) => element.idGroupe == id).toList()[0];
  }

  List<Groupe> getGroupesBy(
      {String? edition, CompetitionPhase phase = CompetitionPhase.tout}) {
    List<Groupe> grps = groupes;
    if (edition != null) {
      grps = grps.where((element) => element.codeEdition == edition).toList();
    }
    if (phase == CompetitionPhase.groupe) {
      grps = grps.where((element) => element.codePhase == 'grp').toList();
    }
    if (phase == CompetitionPhase.elimination) {
      grps = grps.where((element) => element.codePhase != 'grp').toList();
    }
    return grps;
  }
}
