import 'package:app/core/enums/competition_phase_enum.dart';
import 'package:app/models/participation.dart';
import 'package:app/providers/groupe_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/service/participation_service.dart';
import 'package:flutter/material.dart';

class ParticipationProvider extends ChangeNotifier {
  List<Participation> _participations;
  ParticipantProvider participantProvider;
  GroupeProvider groupeProvider;

  ParticipationProvider(
    this._participations, {
    required this.participantProvider,
    required this.groupeProvider,
  });

  Future<List<Participation>> getParticipations() async {
    if (participantProvider.participants.isEmpty)
      await participantProvider.getParticipants();

    if (groupeProvider.groupes.isEmpty) await groupeProvider.getGroupes();
    if (participations.isEmpty)
      participations = await ParticipationService.getData(
          participantProvider.participants, groupeProvider.groupes);

    return participations;
  }

  bool get isEmpty => _participations.isEmpty;
  bool get isNotEmpty => _participations.isNotEmpty;
  List<Participation> get participations => _participations;
  void set participations(List<Participation> val) {
    _participations = val;
    notifyListeners();
  }

  List<Participation> get phaseGroupe =>
      getParticipationsBy(phase: CompetitionPhase.groupe);
  List<Participation> get phaseEliminatoire =>
      getParticipationsBy(phase: CompetitionPhase.elimination);

  void sortById([bool asc = true]) {
    if (asc) {
      _participations
          .sort((a, b) => a.idParticipation.compareTo(b.idParticipation));
    } else
      _participations
          .sort((a, b) => a.idParticipation.compareTo(b.idParticipation));
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
      parts = parts
          .where((element) => element.participant.codeEdition == edition)
          .toList();
    }
    if (groupe != null) {
      parts = parts.where((element) => element.idGroupe == groupe).toList();
    }
    if (phase == CompetitionPhase.groupe) {
      parts =
          parts.where((element) => element.groupe.codePhase == 'grp').toList();
    }
    if (phase == CompetitionPhase.elimination) {
      parts =
          parts.where((element) => element.groupe.codePhase != 'grp').toList();
    }
    return parts;
  }

  Participation? getParticipationsById({required String idParticipant}) {
    try {
      return _participations.firstWhere((element) =>
          element.idParticipant == idParticipant &&
          element.groupe.codePhase == 'grp');
    } catch (e) {
      return null;
    }
  }
}
