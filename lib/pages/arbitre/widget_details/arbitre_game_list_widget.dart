import 'package:app/models/composition.dart';
import 'package:app/models/game.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/app/person_game_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArbitreGameListWidget extends StatelessWidget {
  final String idArbitre;
  const ArbitreGameListWidget({super.key, required this.idArbitre});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<CompositionProvider>().getCompositions(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('erreur!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer2<CompositionProvider, GameProvider>(
              builder: (context, compositionProvider, gameProvider, child) {
            List<ArbitreComposition> compositions = compositionProvider
                .compositionCollection
                .getArbitres()
                .where((element) => element.idArbitre == idArbitre)
                .toList();
            List<String> ids = compositions.map((e) => e.idGame).toList();

            List<Game> maths = gameProvider.games
                .where((element) => ids.contains(element.idGame))
                .toList();

            return maths.isEmpty
                ? const Center(
                    child:
                        Text('Pas de composition disponible pour cet arbitre!'),
                  )
                : PersonGameListWidget(
                    games: maths,
                    gameEventListProvider: gameProvider.gameEventListProvider);
          });
        });
  }
}
