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

  Future<CompetitionCollection> getCompetitions({bool remote = false}) async {
    if (_competitionCollection.isEmpty) {
      competitions = await CompetitionService().getData(remote: remote);
    }
    return _competitionCollection;
  }

  Future<bool> addCompetition(Competition competition) async {
    bool res = await CompetitionService().addCompetition(competition);
    if (res) competitions = await CompetitionService().getData(remote: true);
    return res;
  }

  Future<bool> removeCompetition(String codeEdition) async {
    bool res = await CompetitionService().removeCompetition(codeEdition);
    if (res) competitions = await CompetitionService().getData(remote: true);
    return res;
  }

  Future<bool> editCompetition(
      String codeEdition, Competition competition) async {
    bool res =
        await CompetitionService().editCompetition(codeEdition, competition);
    if (res) competitions = await CompetitionService().getData(remote: true);
    return res;
  }
}
