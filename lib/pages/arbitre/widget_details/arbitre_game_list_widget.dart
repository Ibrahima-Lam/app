import 'package:app/models/composition.dart';
import 'package:app/models/game.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/game_widget.dart';
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
              builder: (context, compos, games, child) {
            List<ArbitreComposition> compositions = compos.compositionCollection
                .getArbitres()
                .where((element) => element.idArbitre == idArbitre)
                .toList();
            List<String> ids = compositions.map((e) => e.idGame).toList();

            List<Game> maths = games.gameCollection.games
                .where((element) => ids.contains(element.idGame))
                .toList();

            return maths.isEmpty
                ? const Center(
                    child:
                        Text('Pas de composition disponible pour cet arbitre!'),
                  )
                : Card(
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                            maths.map((e) => GameFullWidget(game: e)).toList(),
                      ),
                    ),
                  );
          });
        });
  }
}
