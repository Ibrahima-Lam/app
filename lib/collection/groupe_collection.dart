import 'package:fscore/core/enums/competition_phase_enum.dart';
import 'package:fscore/models/groupe.dart';

class GroupeCollection {
  List<Groupe> _groupes;

  GroupeCollection(this._groupes);

  bool get isEmpty => _groupes.isEmpty;
  bool get isNotEmpty => _groupes.isNotEmpty;
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
