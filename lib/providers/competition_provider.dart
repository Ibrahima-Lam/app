import 'package:app/collection/competition_collection.dart';
import 'package:app/models/competition.dart';
import 'package:app/service/competition_service.dart';
import 'package:flutter/material.dart';

class CompetitionProvider extends ChangeNotifier {
  CompetitionCollection _competitionCollection = CompetitionCollection([]);

  void set competitions(List<Competition> val) {
    _competitionCollection = CompetitionCollection(val);
    notifyListeners();
  }

  CompetitionCollection get collection => _competitionCollection;

  Future<CompetitionCollection> getCompetitions() async {
    if (_competitionCollection.isEmpty) {
      competitions = await CompetitionService().getData;
    }
    return _competitionCollection;
  }
}
