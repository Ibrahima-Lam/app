import 'package:app/models/participant.dart';
import 'package:app/service/participant_service.dart';
import 'package:flutter/material.dart';

class ParticipantProvider extends ChangeNotifier {
  List<Participant> participants = [];

  Future setParticipants() async {
    participants = await ParticipantService.getData();
    notifyListeners();
  }

  Future<List<Participant>> getParticipants() async {
    if (participants.length == 0) {
      await setParticipants();
    }
    return participants;
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
