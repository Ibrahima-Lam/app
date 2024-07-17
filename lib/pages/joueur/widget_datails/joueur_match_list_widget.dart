import 'package:app/controllers/joueur/joueur_controller.dart';
import 'package:app/models/composition.dart';
import 'package:app/models/game.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/app/person_game_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoueurMatchListWidget extends StatelessWidget {
  final String idJoueur;
  const JoueurMatchListWidget({super.key, required this.idJoueur});

  Future<void> _getData(BuildContext context) async {
    await context.read<GameProvider>().getGames();
    await context.read<CompositionProvider>().getCompositions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData(context),
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
        return Consumer2<GameProvider, CompositionProvider>(
          builder: (context, gameProvider, compositionProvider, child) {
            List<Game> games = JoueurController.getJoueurConvocation(idJoueur,
                compositions: compositionProvider
                    .compositionCollection.compositions
                    .whereType<JoueurComposition>()
                    .toList(),
                games: gameProvider.games);

            return games.isEmpty
                ? Center(
                    child:
                        Text('Pas de composition disponible pour ce joueur!'),
                  )
                : PersonGameListWidget(
                    games: games,
                    gameEventListProvider: gameProvider.gameEventListProvider,
                  );
          },
        );
      },
    );
  }
}
