import 'package:fscore/models/game.dart';
import 'package:fscore/providers/game_provider.dart';
import 'package:fscore/widget/game/game_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameListWidget extends StatelessWidget {
  final String idParticipant;
  const GameListWidget({super.key, required this.idParticipant});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<GameProvider>().getGames(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Erreur de chargement!'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            List<Game> games =
                gameProvider.getGamesBy(idParticipant: idParticipant);
            return games.isEmpty
                ? const Center(
                    child: Text('Pas de match disponible pour cette equipe!'),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: games
                          .map((e) => GameFullWidget(
                              gameEventListProvider:
                                  gameProvider.gameEventListProvider,
                              game: e,
                              verticalMargin: 1,
                              elevation: 1))
                          .toList(),
                    ),
                  );
          },
        );
      },
    );
  }
}
