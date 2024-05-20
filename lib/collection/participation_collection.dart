import 'package:app/collection/collection.dart';
import 'package:app/core/enums/competition_phase_enum.dart';
import 'package:app/models/participation.dart';

class ParticipationCollection implements Collection {
  List<Participation> _participations;

  ParticipationCollection(this._participations);

  bool get isEmpty => _participations.isEmpty;
  bool get isNotEmpty => _participations.isNotEmpty;
  List<Participation> get participations => _participations;
  void set participations(List<Participation> val) => _participations = val;

  List<Participation> get phaseGroupe =>
      getParticipationsBy(phase: CompetitionPhase.groupe);
  List<Participation> get phaseEliminatoire =>
      getParticipationsBy(phase: CompetitionPhase.elimination);

  void sortById([bool asc = true]) {
    if (asc) {
      _participations
          .sort((a, b) => a.idParticipation!.compareTo(b.idParticipation!));
    } else
      _participations
          .sort((a, b) => a.idParticipation!.compareTo(b.idParticipation!));
  }

  Participation getElementAt(String id) {
    return _participations
        .where((element) => element.idParticipation == id)
        .toList()[0];
  }

  List<Participation> getParticipationsBy(
      {String? edition,
      String? groupe,
      CompetitionPhase phase = CompetitionPhase.tout}) {
    List<Participation> parts = _participations;
    if (edition != null) {
      parts = parts.where((element) => element.codeEdition == edition).toList();
    }
    if (groupe != null) {
      parts = parts.where((element) => element.idGroupe == groupe).toList();
    }
    if (phase == CompetitionPhase.groupe) {
      parts = parts.where((element) => element.codePhase == 'grp').toList();
    }
    if (phase == CompetitionPhase.elimination) {
      parts = parts.where((element) => element.codePhase != 'grp').toList();
    }
    return parts;
  }
}
