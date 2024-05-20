import 'package:app/collection/game_collection.dart';
import 'package:app/controllers/niveau/niveau_controller.dart';
import 'package:app/models/competition.dart';
import 'package:app/models/game.dart';
import 'package:app/models/niveau.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/game_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchsWidget extends StatelessWidget {
  final Competition competition;
  const MatchsWidget({
    super.key,
    required this.competition,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<GameProvider>().getGames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur!'),
            );
          }

          return Consumer<GameProvider>(builder: (context, value, child) {
            final GameCollection gameCollection = value.gameCollection;
            final List<Game> games =
                gameCollection.getGamesBy(codeEdition: competition.codeEdition);
            final List<Niveau> niveaux = NiveauController.getGamesNiveau(games);
            if (niveaux.isEmpty) {
              return const Center(
                child: Text('Pas de Données!'),
              );
            }
            return ListView(
              children: niveaux.map((niveau) {
                final List<Game> matchs = gameCollection.getGamesBy(
                    codeNiveau: niveau.codeNiveau,
                    codeEdition: competition.codeEdition);
                final List<Widget> matchsWidget = [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      color: Color(0xFFE0E0E0),
                      padding: const EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Text(
                        niveau.nomNiveau!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ];
                matchsWidget
                    .addAll(matchs.map((match) => GameWidget(game: match)));
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: matchsWidget,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          });
        });
  }
}
