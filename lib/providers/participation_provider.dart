import 'package:app/collection/participation_collection.dart';
import 'package:app/models/participation.dart';
import 'package:app/service/participation_service.dart';
import 'package:flutter/material.dart';

class ParticipationProvider extends ChangeNotifier {
  ParticipationCollection _participationCollection =
      ParticipationCollection([]);

  ParticipationCollection get collection => _participationCollection;

  void set participations(List<Participation> val) {
    _participationCollection = ParticipationCollection(val);
    notifyListeners();
  }

  Future<ParticipationCollection> getParticipations() async {
    if (_participationCollection.isEmpty) {
      participations = await ParticipationService().getData();
    }
    return _participationCollection;
  }
}
