import 'package:fscore/controllers/niveau/niveau_controller.dart';
import 'package:fscore/core/extension/string_extension.dart';
import 'package:fscore/models/competition.dart';
import 'package:fscore/models/game.dart';
import 'package:fscore/models/niveau.dart';
import 'package:fscore/pages/forms/game_form.dart';
import 'package:fscore/providers/game_event_list_provider.dart';
import 'package:fscore/providers/game_provider.dart';
import 'package:fscore/providers/paramettre_provider.dart';
import 'package:fscore/widget/game/game_widget.dart';
import 'package:fscore/widget/modals/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class MatchsWidget extends StatefulWidget {
  final Competition competition;
  const MatchsWidget({
    super.key,
    required this.competition,
  });

  @override
  State<MatchsWidget> createState() => _MatchsWidgetState();
}

class _MatchsWidgetState extends State<MatchsWidget> {
  _onEdit(Game game) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GameForm(
              game: game,
              codeEdition: widget.competition.codeEdition,
            )));
  }

  _onDelete(Game game) async {
    final bool confirm = await showDialog(
        context: context,
        builder: (context) => ConfirmDialogWidget(
            title: 'Supprimer le match',
            content: 'Voulez-vous supprimer le match ?'));
    if (confirm) {
      context.read<GameProvider>().removeGame(game.idGame);
    }
  }

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

          return Consumer2<GameProvider, ParamettreProvider>(
              builder: (context, gameProvider, paramettreProvider, child) {
            final bool enabled =
                paramettreProvider.checkUser(widget.competition.codeEdition);
            final List<Game> games = gameProvider.getGamesBy(
                codeEdition: widget.competition.codeEdition);
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
                      codeEdition: widget.competition.codeEdition);
                  final List<Widget> matchsWidget = [
                    GestureDetector(
                      onTap: () {},
                      child: Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                        shadowColor: Colors.grey,
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
                            niveau.nomNiveau.capitalize(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ];
                  matchsWidget.addAll(matchs.map((match) => GameTileWidget(
                        enabled: enabled,
                        onDelete: _onDelete,
                        onEdit: _onEdit,
                        game: match,
                        gameEventListProvider:
                            gameProvider.gameEventListProvider,
                      )));
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: matchsWidget,
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

class GameTileWidget extends StatelessWidget {
  final Game game;
  final bool enabled;
  final GameEventListProvider gameEventListProvider;
  final Function(Game) onDelete;
  final Function(Game) onEdit;
  const GameTileWidget(
      {super.key,
      required this.enabled,
      required this.game,
      required this.gameEventListProvider,
      required this.onDelete,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Slidable(
        enabled: enabled,
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: (context) => onDelete(game),
              icon: Icons.delete,
              foregroundColor: Colors.red,
            ),
          ],
        ),
        endActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onEdit(game),
              icon: Icons.edit,
            ),
          ],
        ),
        child: GameLessWidget(
            game: game, gameEventListProvider: gameEventListProvider));
  }
}
