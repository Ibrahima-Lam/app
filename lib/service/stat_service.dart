import 'package:app/collection/game_collection.dart';
import 'package:app/collection/groupe_collection.dart';
import 'package:app/collection/participation_collection.dart';
import 'package:app/controllers/classement/classeur.dart';
import 'package:app/core/enums/competition_phase_enum.dart';
import 'package:app/models/game.dart';
import 'package:app/models/groupe.dart';
import 'package:app/models/participation.dart';
import 'package:app/models/stat.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/providers/groupe_provider.dart';
import 'package:app/providers/participation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatService {
  final BuildContext context;
  const StatService({required this.context});

  Future<List<Stat>> getStatByGroupe({required String idGroupe}) async {
    final GameCollection gameCollection =
        await context.read<GameProvider>().getGames();

    final ParticipationCollection participationCollection =
        await context.read<ParticipationProvider>().getParticipations();
    final List<Participation> teams =
        participationCollection.getParticipationsBy(groupe: idGroupe);
    final List<Game> matchs =
        gameCollection.getGamesBy(idGroupe: idGroupe, played: true);
    final List<Stat> stats = Classeur(games: matchs, equipes: teams).classer();
    return stats;
  }

  Future<Map<String, List<Stat>>> getStatByEdition(
      {required String codeEdition}) async {
    final GameCollection gameCollection =
        await context.read<GameProvider>().getGames();

    final ParticipationCollection participationCollection =
        await context.read<ParticipationProvider>().getParticipations();
    final GroupeCollection groupeCollection =
        await context.read<GroupeProvider>().getGroupes();
    final List<Groupe> groupes = groupeCollection.getGroupesBy(
        edition: codeEdition, phase: CompetitionPhase.groupe);
    final Map<String, List<Stat>> stats = {};
    for (Groupe groupe in groupes) {
      final List<Participation> teams =
          participationCollection.getParticipationsBy(groupe: groupe.idGroupe);
      final List<Game> matchs =
          gameCollection.getGamesBy(idGroupe: groupe.idGroupe, played: true);
      final List<Stat> stat = Classeur(games: matchs, equipes: teams).classer();
      stats[groupe.nomGroupe!] = stat;
    }
    return stats;
  }
}
