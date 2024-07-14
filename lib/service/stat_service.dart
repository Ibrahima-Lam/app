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

  Future<List<Stat>> getStatByEquipe({required String idParticipant}) async {
    final ParticipationProvider participationProvider =
        context.read<ParticipationProvider>();
    await participationProvider.getParticipations();
    final Participation? participation = participationProvider
        .getParticipationsById(idParticipant: idParticipant);
    if (participation == null) return [];

    final String idGroupe = participation.idGroupe;

    return await getStatByGroupe(idGroupe: idGroupe);
  }

  Future<List<Stat>> getStatByGroupe({required String idGroupe}) async {
    final GameProvider gameProvider = context.read<GameProvider>();
    await gameProvider.getGames();

    final ParticipationProvider participationProvider =
        context.read<ParticipationProvider>();
    await participationProvider.getParticipations();
    final List<Participation> teams =
        participationProvider.getParticipationsBy(groupe: idGroupe);
    final List<Game> matchs =
        gameProvider.getGamesBy(idGroupe: idGroupe, played: true);
    final List<Stat> stats = Classeur(games: matchs, equipes: teams).classer();
    return stats;
  }

  Future<Map<String, List<Stat>>> getStatByEdition(
      {required String codeEdition}) async {
    final ParticipationProvider participationProvider =
        context.read<ParticipationProvider>();
    await participationProvider.getParticipations();
    final GroupeProvider groupeProvider = await context.read<GroupeProvider>()
      ..getGroupes();
    final List<Groupe> groupes = groupeProvider.getGroupesBy(
        edition: codeEdition, phase: CompetitionPhase.groupe);
    final Map<String, List<Stat>> stats = {};
    for (Groupe groupe in groupes) {
      List<Stat> stat = await getStatByGroupe(idGroupe: groupe.idGroupe);
      stats[groupe.nomGroupe!] = stat;
    }
    return stats;
  }
}
