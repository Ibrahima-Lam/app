import 'package:app/core/constants/statistique/kStatistique.dart';
import 'package:app/models/game.dart';
import 'package:app/models/gameEvent.dart';
import 'package:app/models/statistique.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/providers/statistique_future_provider.dart';
import 'package:app/service/statistique_service.dart';
import 'package:flutter/material.dart';

class StatistiqueProvider extends ChangeNotifier {
  StatistiqueFutureProvider statistiqueFutureProvider;
  GameEventListProvider gameEventListProvider;
  final List<Statistique> _statistiques = [];
  StatistiqueProvider(
      this.statistiqueFutureProvider, this.gameEventListProvider) {
    statistiques = statistiqueFutureProvider.statistiques;
  }

  Future<void> getData() async {
    statistiques = await StatistiqueService.getData();
  }

  List<Statistique> get statistiques => _statistiques;
  void set statistiques(List<Statistique> val) {
    _statistiques.clear();
    _statistiques.addAll(val);
  }

  List<Statistique> getGameStatistiques(Game game) {
    List<Statistique> stats =
        statistiques.where((element) => element.idGame == game.idGame).toList();
    var jauneStat = gameEventListProvider.getYellowCardStat(game);
    var rougeStat = gameEventListProvider.getRedCardStat(game);
    if (!stats.any((element) => element.codeStatistique.contains('jaune')) &&
        jauneStat != (0, 0)) {
      stats.add(Statistique(
        idStatistique: 'GCJ${game.idGame}',
        codeStatistique: 'jaune',
        nomStatistique: 'Carton Jaune',
        homeStatistique: jauneStat.$1.toDouble(),
        awayStatistique: jauneStat.$2.toDouble(),
        idGame: game.idGame,
        isFromEvent: true,
      ));
    }

    if (!stats.any((element) => element.codeStatistique.contains('rouge')) &&
        rougeStat != (0, 0)) {
      stats.add(Statistique(
        idStatistique: 'GCR${game.idGame}',
        codeStatistique: 'rouge',
        nomStatistique: 'Carton rouge',
        homeStatistique: rougeStat.$1.toDouble(),
        awayStatistique: rougeStat.$2.toDouble(),
        idGame: game.idGame,
        isFromEvent: true,
      ));
    }
    return stats;
  }

  GameEvent getGameCardAndPossession(Game game) {
    final Statistique yellow = getGameStatistiques(game).firstWhere(
        (element) => element.codeStatistique.contains('jaune'),
        orElse: () => kYellowStatistique);
    final Statistique red = getGameStatistiques(game).firstWhere(
        (element) => element.codeStatistique.contains('rouge'),
        orElse: () => kRedStatistique);
    final Statistique possession = getGameStatistiques(game).firstWhere(
      (element) => element.codeStatistique.contains('possession'),
      orElse: () => kPossesionStatistique,
    );
    return GameEvent(
      game: game,
      homeEvent: EventStream(
          pourcent: possession.homeStatistique,
          idParticipant: game.idHome,
          redCard: red.homeStatistique.toInt(),
          yellowCard: yellow.homeStatistique.toInt()),
      awayEvent: EventStream(
          pourcent: possession.awayStatistique,
          idParticipant: game.idAway,
          redCard: red.awayStatistique.toInt(),
          yellowCard: yellow.awayStatistique.toInt()),
    );
  }
}
