import 'package:app/core/enums/competition_phase_enum.dart';
import 'package:app/core/extension/list_extension.dart';
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

  Future<List<Participation>> getParticipations({bool remote = false}) async {
    if (participantProvider.participants.isEmpty)
      await participantProvider.getParticipants(remote: remote);

    if (groupeProvider.groupes.isEmpty)
      await groupeProvider.getGroupes(remote: remote);
    if (participations.isEmpty || remote)
      participations = await ParticipationService.getData(
          participantProvider.participants, groupeProvider.groupes,
          remote: remote);

    return participations;
  }

  Future<bool> addParticipation(Participation participation) async {
    final bool res = await ParticipationService.addParticipation(participation);
    if (res) await getParticipations(remote: true);
    return res;
  }

  Future<bool> removeParticipation(String idParticipation) async {
    final bool res =
        await ParticipationService.removeParticipation(idParticipation);
    if (res) await getParticipations(remote: true);
    return res;
  }

  Future<bool> editParticipation(
      String idParticipation, Participation participant) async {
    final bool res = await ParticipationService.editParticipation(
        idParticipation, participant);
    if (res) await getParticipations(remote: true);
    return res;
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

  Participation? getParticipationByGroupeOrEquipe(
      {required String? idParticipant, required String? idGroupe}) {
    return _participations.singleWhereOrNull((element) =>
        (element.idParticipant == idParticipant ||
            element.groupe.idGroupe == idGroupe) &&
        element.groupe.codePhase == 'grp');
  }
}
