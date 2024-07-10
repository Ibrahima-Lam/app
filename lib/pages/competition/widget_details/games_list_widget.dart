import 'package:app/controllers/niveau/niveau_controller.dart';
import 'package:app/core/extension/string_extension.dart';
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
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur!'),
            );
          }

          return Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
            final List<Game> games =
                gameProvider.getGamesBy(codeEdition: competition.codeEdition);
            final List<Niveau> niveaux = NiveauController.getGamesNiveau(games);
            if (niveaux.isEmpty) {
              return const Center(
                child: Text('Pas de Données!'),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: niveaux.map((niveau) {
                  final List<Game> matchs = gameProvider.getGamesBy(
                      codeNiveau: niveau.codeNiveau,
                      codeEdition: competition.codeEdition);
                  final List<Widget> matchsWidget = [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 215, 238, 215),
                          Color(0xFFF5F5F5)
                        ])),
                        child: Text(
                          niveau.nomNiveau!.capitalize(),
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
              ),
            );
          });
        });
  }
}
