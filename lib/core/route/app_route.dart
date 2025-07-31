import 'package:flutter/material.dart';
import 'package:fscore/models/api/fixture.dart';
import 'package:fscore/pages/competition/league_details.dart';
import 'package:fscore/pages/equipe/team_details.dart';
import 'package:fscore/pages/game/fixture_details.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/league_details': (context) {
    final League? league =
        ModalRoute.of(context)?.settings.arguments as League?;
    return LeagueDetails(league: league ?? League());
  },
  '/fixture_details': (context) {
    final Fixture? fixture =
        ModalRoute.of(context)?.settings.arguments as Fixture?;
    return FixtureDetails(
        fixture: fixture ??
            Fixture(
                fixture: FixtureDetail(),
                teams: Teams(
                  home: Team(id: 0, name: '', logo: ''),
                  away: Team(id: 0, name: '', logo: ''),
                )));
  },
  '/team_details': (context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return TeamDetails(
        team: args?['team'] ?? Team(id: 0, name: '', logo: ''),
        league: args?['league'] ?? League());
  },
};
