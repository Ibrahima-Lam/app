import 'package:app/controllers/joueur/joueur_controller.dart';
import 'package:app/core/enums/performance_type.dart';
import 'package:app/core/extension/string_extension.dart';
import 'package:app/models/joueur.dart';
import 'package:app/models/performance.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/game/game_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoueurPerformanceWidget extends StatelessWidget {
  final Joueur joueur;
  const JoueurPerformanceWidget({super.key, required this.joueur});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: null,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('erreur!'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Consumer2<GameProvider, GameEventListProvider>(
          builder: (context, gameProvider, events, child) {
            List<GamePerformances> gamePerformances =
                JoueurController.getJoueurPerformance(joueur,
                    games: gameProvider.games, events: events.events);

            return gamePerformances.isEmpty
                ? const Center(
                    child:
                        Text('Pas de Performance disponible pour ce joueur!'),
                  )
                : SingleChildScrollView(
                    child: Column(children: [
                      const SizedBox(height: 5),
                      ...gamePerformances
                          .map((e) => PerformanceSetionWidget(
                                gameEventListProvider:
                                    gameProvider.gameEventListProvider,
                                gamePerformances: e,
                              ))
                          .toList(),
                    ]),
                  );
          },
        );
      },
    );
  }
}

class PerformanceSetionWidget extends StatelessWidget {
  final GamePerformances gamePerformances;
  final GameEventListProvider gameEventListProvider;
  const PerformanceSetionWidget(
      {super.key,
      required this.gamePerformances,
      required this.gameEventListProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...gamePerformances.performances
            .map((e) => PerformanceWidget(performance: e))
            .toList(),
        GameLessWidget(
          game: gamePerformances.game,
          gameEventListProvider: gameEventListProvider,
        ),
        SizedBox(height: 5),
      ],
    );
  }
}

class PerformanceWidget extends StatelessWidget {
  final Performance performance;
  const PerformanceWidget({super.key, required this.performance});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      shadowColor: Colors.grey,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              performance.title.capitalize(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Row(
              children: List.generate(
                  performance.nombre,
                  (index) => Icon(performance.type == PerformanceType.but
                      ? Icons.sports_soccer
                      : Icons.arrow_forward)),
            )
          ],
        ),
      ),
    );
  }
}
