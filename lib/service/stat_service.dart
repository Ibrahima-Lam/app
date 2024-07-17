import 'package:app/controllers/classement/classeur.dart';
import 'package:app/core/enums/competition_phase_enum.dart';
import 'package:app/core/extension/list_extension.dart';
import 'package:app/core/params/categorie/classement/classement_params.dart';
import 'package:app/models/game.dart';
import 'package:app/models/groupe.dart';
import 'package:app/models/paramettre.dart';
import 'package:app/models/participation.dart';
import 'package:app/models/stat.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/providers/groupe_provider.dart';
import 'package:app/providers/paramettre_provider.dart';
import 'package:app/providers/participation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatService {
  final BuildContext context;
  final String codeEdition;

  const StatService({
    required this.context,
    required this.codeEdition,
  });

  Future<int> _qualifs(int parts) async {
    ParamettreProvider paramettreProvider = context.read<ParamettreProvider>();
    if (paramettreProvider.paramettres.isEmpty)
      await paramettreProvider.getData();
    Paramettre? paramettre = paramettreProvider.paramettres
        .singleWhereOrNull((element) => element.idEdition == codeEdition);
    if (paramettre != null) {
      if (paramettre.qualifs != null) return paramettre.qualifs!;
    }
    List<int> elements = [0, 2, 4, 8, 16, 32, 64];
    print(parts);
    if (elements.contains(parts ~/ 2)) parts ~/ 2;
    for (int i = 1; i < elements.length; i++) {
      int element = elements[i];
      if (element == (parts / 2).ceil()) return element;
      int min = elements[i - 1];

      double v = parts / 2;
      if (v > min && v <= element) {
        if (element - v <= v - min)
          return element;
        else
          return min;
      }
    }
    return 0;
  }

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
    final GroupeProvider groupeProvider = context.read<GroupeProvider>();
    await groupeProvider.getGroupes();
    List<Groupe> groupes = groupeProvider.groupes
        .where((element) =>
            element.codeEdition == codeEdition && element.codePhase == 'grp')
        .toList();
    final List<Participation> teams = participationProvider.getParticipationsBy(
        edition: codeEdition, phase: CompetitionPhase.groupe);
    final List<Game> matchs = gameProvider.getGamesBy(played: true);
    int qualifs = await _qualifs(teams.length);
    final List<Stat> stats = Classeur(
        games: matchs,
        equipes: teams,
        groupes: groupes,
        classements: ClassementParams(
          success: qualifs,
        )).classer(idGroupe);
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
      stats[groupe.nomGroupe] = stat;
    }
    return stats;
  }
}
