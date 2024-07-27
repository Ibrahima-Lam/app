import 'package:app/controllers/classement/classeur_controller.dart';
import 'package:app/controllers/classement/classeur_ripository.dart';
import 'package:app/models/game.dart';
import 'package:app/models/groupe.dart';
import 'package:app/models/participation.dart';
import 'package:app/models/stat.dart';

final class Classeur extends ClasseurRipository {
  final List<Groupe> groupes;

  const Classeur({
    required super.games,
    required super.equipes,
    this.groupes = const [],
    required super.classements,
  });

  List<Participation> getGroupeParticipation(String idGroupe) {
    return equipes.where((element) => element.idGroupe == idGroupe).toList();
  }

  List<Stat> classerTous({
    List<String>? criteres,
    int Function(Stat, Stat)? callback,
  }) {
    List<Stat> stats = [];
    for (var groupe in groupes) {
      final List<Participation> parts = getGroupeParticipation(groupe.idGroupe);
      final List<Game> matchs = games
          .where((element) => element.idGroupe == groupe.idGroupe)
          .toList();
      stats.addAll((ClasseurController(
              equipes: parts, games: matchs, classements: classements)
          .classe(
        criteres: criteres ?? criteresDefaut,
        callback: callback,
      )));
    }
    stats.sort((a, b) {
      if (a.num - b.num != 0) return a.num - b.num;
      if (b.pts - a.pts != 0) return b.pts - a.pts;
      return b.diff - a.diff;
    });
    stats = stats.asMap().entries.map(
      (e) {
        e.value.position = e.key + 1;

        return e.value;
      },
    ).toList();
    return stats;
  }

  List<Stat> classer(
    String idGroupe, {
    List<String>? criteres,
    int Function(Stat, Stat)? callback,
    List<Groupe>? groupes,
  }) {
    final List<Participation> parts = getGroupeParticipation(idGroupe);
    final List<Game> matchs =
        games.where((element) => element.idGroupe == idGroupe).toList();
    if (matchs.isEmpty) {
      return [];
    }
    return ClasseurController(
      equipes: parts,
      games: matchs,
      classements: classements,
    ).classe(
        criteres: criteres ?? criteresDefaut,
        callback: callback,
        allStat: classerTous(criteres: criteres, callback: callback));
  }
}
