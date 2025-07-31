import 'package:fscore/models/api/fixture.dart' show Fixture, League;
import 'package:fscore/models/game.dart';
import 'package:fscore/service/fixture_service.dart';

import 'package:flutter/material.dart';

typedef GameList = List<Game>;

class FixtureProvider extends ChangeNotifier {
  List<Fixture> _fixtures = [];
  List<League> _leagues = [];
  final FixtureService fixtureService;
  static DateTime? lastUpdate;
  FixtureProvider(this.fixtureService);
  /* int _index = 2;
  int get index => _index;
  void set index(int val) {
    _index = val;
    notifyListeners();
  } */

  Map<String, List<Fixture>> fixturesByDate = {};

  List<Fixture> get fixtures => _fixtures;

  Future<bool> LoadFixtures({required String date}) async {
    await getFixtures(date: date, remote: true);
    if (_fixtures.isNotEmpty) notifyListeners();
    return _fixtures.isNotEmpty;
  }

  Future<List<Fixture>> getFixtures(
      {required String date, bool remote = false, bool live = false}) async {
    double duration = DateTime.now()
        .difference(lastUpdate ?? DateTime.now())
        .inMinutes
        .toDouble();

    if (live) {
      _fixtures = await fixtureService.getLiveFixtures();
    } else if (duration < 5) {
      if (fixturesByDate.containsKey(date)) {
        _fixtures = fixturesByDate[date]!;
      } else {
        _fixtures = await fixtureService.getFixtures(date: date);
        _fixtures.sort(_sortFixture);
        if (_fixtures.isNotEmpty) fixturesByDate[date] = _fixtures;
      }
      lastUpdate = DateTime.now();
    } else if (remote ||
        _fixtures.isEmpty && !live ||
        !_fixtures.any((e) => e.fixture.dateString == date)) {
      _fixtures = await fixtureService.getFixtures(date: date);
      _fixtures.sort(_sortFixture);
      if (_fixtures.isNotEmpty) fixturesByDate[date] = _fixtures;
      lastUpdate = DateTime.now();
    }
    setLeagues();
    return _fixtures;
  }

  int _sortFixture(Fixture a, Fixture b) {
    if (a.league?.id == b.league?.id) {
      return a.league?.id?.compareTo(b.league?.id ?? 0) ?? 0;
    }
    return a.fixture.date?.compareTo(b.fixture.date ?? '') ?? 0;
  }

  List<League> get leagues => _leagues;

  void setLeagues() {
    List<League> res = [];
    List<int> ids = [];
    for (var fixture in _fixtures) {
      if (!ids.contains(fixture.league?.id ?? 0)) {
        ids.add(fixture.league?.id ?? 0);
        if (fixture.league != null) res.add(fixture.league!);
      }
    }
    _leagues = res;
  }

  List<Fixture> getFixturesByLeague(int idLeague) {
    return _fixtures
        .where((element) => element.league?.id == idLeague)
        .toList();
  }
}
