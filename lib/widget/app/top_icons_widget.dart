import 'package:app/core/enums/categorie_enum.dart';
import 'package:app/models/competition.dart';
import 'package:app/models/event.dart';
import 'package:app/models/game.dart';
import 'package:app/models/joueur.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/logos/circular_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopIconsWidget extends StatelessWidget {
  final List<Competition> competitions;
  final String dateGame;
  final GameProvider gameProvider;
  final bool playing;
  const TopIconsWidget(
      {super.key,
      required this.competitions,
      required this.dateGame,
      required this.gameProvider,
      required this.playing});
  List<Game> get games => gameProvider
      .getGamesBy(playing: playing, dateGame: dateGame)
      .reversed
      .toList();

  List<Game> get lastGames => [
        ...gameProvider.games.reversed
            .where(
              (element) =>
                  element.dateGame!.compareTo(dateGame) <= 0 &&
                  lastComps.elementAtOrNull(0)?.codeEdition ==
                      element.groupe.codeEdition,
            )
            .take(2)
            .toList(),
        ...gameProvider.games.reversed
            .where(
              (element) =>
                  element.dateGame!.compareTo(dateGame) <= 0 &&
                  lastComps.elementAtOrNull(1)?.codeEdition ==
                      element.groupe.codeEdition,
            )
            .take(2)
            .toList(),
      ];
  List<Competition> get comps => competitions
      .where((element) =>
          games.any((e) => e.groupe.codeEdition == element.codeEdition))
      .toList();
  List<Competition> get lastComps => [
        ...comps,
        ...competitions
            .where((element) =>
                gameProvider.played.reversed
                    .any((e) => e.groupe.codeEdition == element.codeEdition) &&
                !comps.any(
                  (elmt) => element.codeEdition == elmt.codeEdition,
                ))
            .toList()
      ].take(2).toList();

  List<Widget> getWidtgetsByGames(List<Game> games,
      JoueurProvider joueurProvider, GameEventListProvider eventProvider) {
    games.sort((a, b) => (a.dateGame ?? '').compareTo(b.dateGame ?? ''));
    return [
      ...games.expand((element) sync* {
        List<GoalEvent> goals = eventProvider.events
            .whereType<GoalEvent>()
            .where((element) => games.any((e) => element.idGame == e.idGame))
            .toList();

        yield CircularLogoWidget(
          path: element.home.imageUrl ?? '',
          categorie: Categorie.equipe,
          id: element.idHome,
          tap: true,
        );
        List<Joueur> homePlayers = joueurProvider.joueurs
            .where((pl) => pl.idParticipant == element.idHome)
            .where(
                (element) => goals.any((e) => element.idJoueur == e.idJoueur))
            .toList();
        yield* homePlayers.map((p) => CircularLogoWidget(
            path: p.imageUrl ?? '',
            categorie: Categorie.joueur,
            tap: true,
            id: p.idJoueur));

        yield CircularLogoWidget(
          path: element.away.imageUrl ?? '',
          categorie: Categorie.equipe,
          id: element.idAway,
          tap: true,
        );
        List<Joueur> awayPlayers = joueurProvider.joueurs
            .where((pl) => pl.idParticipant == element.idAway)
            .where(
                (element) => goals.any((e) => element.idJoueur == e.idJoueur))
            .toList();
        yield* awayPlayers.map((p) => CircularLogoWidget(
            path: p.imageUrl ?? '',
            categorie: Categorie.joueur,
            tap: true,
            id: p.idJoueur));
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<JoueurProvider, GameEventListProvider>(
        builder: (context, joueurProvider, eventProvider, _) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        width: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Builder(builder: (context) {
            List<Widget> elements = [
              ...lastComps.map((e) {
                return CircularLogoWidget(
                  path: e.imageUrl ?? '',
                  categorie: Categorie.competition,
                  id: e.codeEdition,
                  tap: true,
                );
              }),
              ...getWidtgetsByGames(lastGames, joueurProvider, eventProvider),
            ].take(20).toList().reversed.toList();

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: elements,
            );
          }),
        ),
      );
    });
  }
}
