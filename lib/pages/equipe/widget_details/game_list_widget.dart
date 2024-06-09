import 'package:app/models/game.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/game_widget.dart';
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
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        }
        return Consumer<GameProvider>(
          builder: (context, value, child) {
            List<Game> games =
                value.gameCollection.getGamesBy(idPartcipant: idParticipant);
            return Card(
              child: ListView.builder(
                itemCount: games.length,
                itemBuilder: (context, index) => GameWidget(game: games[index]),
              ),
            );
          },
        );
      },
    );
  }
}
