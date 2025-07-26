import 'package:fscore/collection/competition_collection.dart';
import 'package:fscore/models/competition.dart';
import 'package:fscore/service/competition_service.dart';
import 'package:flutter/material.dart';

class CompetitionProvider extends ChangeNotifier {
  CompetitionCollection _competitionCollection = CompetitionCollection([]);

  void set competitions(List<Competition> val) {
    _competitionCollection = CompetitionCollection(val);
    notifyListeners();
  }

  CompetitionCollection get collection => _competitionCollection;

  Future<CompetitionCollection> getCompetitions(
      {bool remote = false, bool locale = false}) async {
    if (_competitionCollection.isEmpty || remote || locale) {
      competitions = await CompetitionService().getData(remote: remote);
      notifyListeners();
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
