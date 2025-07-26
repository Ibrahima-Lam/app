import 'package:fscore/models/participant.dart';
import 'package:fscore/service/participant_service.dart';
import 'package:flutter/material.dart';

class ParticipantProvider extends ChangeNotifier {
  List<Participant> participants = [];

  Future setParticipants({bool remote = false}) async {
    participants = await ParticipantService.getData();
    notifyListeners();
  }

  Future initParticipants({bool remote = false}) async {
    participants = await ParticipantService.getData();
  }

  Future<List<Participant>> getParticipants({bool remote = false}) async {
    if (participants.length == 0 || remote) {
      await setParticipants(remote: remote);
    }
    return participants;
  }

  Future<bool> addParticipant(Participant participant) async {
    final bool res = await ParticipantService.addParticipant(participant);
    if (res) await getParticipants(remote: true);
    return res;
  }

  Future<bool> removeParticipant(String idParticipant) async {
    final bool res = await ParticipantService.removeParticipant(idParticipant);
    if (res) await getParticipants(remote: true);
    return res;
  }

  Future<bool> editParticipant(
      String idParticipant, Participant participant) async {
    final bool res =
        await ParticipantService.editParticipant(idParticipant, participant);
    if (res) await getParticipants(remote: true);
    return res;
  }

  Future<Participant> getParticipant(String id) async {
    if (participants.isEmpty) {
      await setParticipants();
    }
    return participants.firstWhere((element) => element.idParticipant == id);
  }

  Future<List<Participant>> getParticipantByEdition(String edition) async {
    if (participants.length == 0) {
      participants = await ParticipantService.getData();
      notifyListeners();
    }
    return participants
        .where((element) => element.codeEdition == edition)
        .toList();
  }
}
