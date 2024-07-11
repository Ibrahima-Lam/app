import 'package:app/models/game.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/game_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JourneeWidget extends StatelessWidget {
  final Game game;

  const JourneeWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<GameProvider>().getGames(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('erreur!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Consumer<GameProvider>(builder: (context, val, child) {
            final List<Game> games = val.getGamesBy(
                idGroupe: game.idGroupe, codeNiveau: game.codeNiveau);
            return Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (Game game in games)
                      GameFullWidget(
                        game: game,
                        verticalMargin: 1,
                        elevation: 0,
                      ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
