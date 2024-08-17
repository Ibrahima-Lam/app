import 'package:app/controllers/competition/date.dart';
import 'package:app/controllers/joueur/joueur_controller.dart';
import 'package:app/core/enums/event_type_enum.dart';
import 'package:app/core/extension/string_extension.dart';
import 'package:app/models/event.dart';
import 'package:app/models/game.dart';
import 'package:app/models/joueur.dart';
import 'package:app/models/participant.dart';
import 'package:app/pages/game/game_details.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/events/composition_events_widget.dart';
import 'package:app/widget/logos/equipe_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoueurStatistiqueWidget extends StatelessWidget {
  final Joueur joueur;
  const JoueurStatistiqueWidget({super.key, required this.joueur});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: null,
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
        return Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            List<EventStatistique> eventStatistiques =
                JoueurController.getJoueurStatistique(joueur,
                        events: gameProvider.gameEventListProvider.events)
                    .where((element) => element.nombre > 0)
                    .toList();
            List<GameEventsStatistique> gameEventsStatistiques =
                JoueurController.getJoueurEventsStatistique(joueur,
                    events: gameProvider.gameEventListProvider.events,
                    games: gameProvider.games);
            return gameEventsStatistiques.isEmpty
                ? const Center(
                    child:
                        Text('Pas de statistique disponible pour ce joueur!'),
                  )
                : SingleChildScrollView(
                    child: Column(children: [
                      const SizedBox(
                        height: 5.0,
                      ),
                      ...eventStatistiques
                          .map((e) => JoueurStatistiqueSectionWidget(
                              eventStatistique: e,
                              gameEventsStatistique: gameEventsStatistiques
                                  .where((element) => element.type == e.type)
                                  .toList(),
                              gameEventListProvider:
                                  gameProvider.gameEventListProvider))
                          .toList()
                    ]),
                  );
          },
        );
      },
    );
  }
}

class JoueurStatistiqueSectionWidget extends StatelessWidget {
  final EventStatistique eventStatistique;
  final GameEventListProvider gameEventListProvider;
  final List<GameEventsStatistique> gameEventsStatistique;
  JoueurStatistiqueSectionWidget({
    super.key,
    required this.eventStatistique,
    required this.gameEventsStatistique,
    required this.gameEventListProvider,
  });
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      JoueurStatistiqueListTileWidget(eventStatistique: eventStatistique),
      Padding(
        padding: const EdgeInsets.only(
          bottom: 5,
          right: 5,
          left: 5,
        ),
        child: Scrollbar(
          radius: Radius.circular(4),
          controller: scrollController,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 5),
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: gameEventsStatistique
                    .where((element) => element.type == eventStatistique.type)
                    .map(
                      (e) => GameJoueurStatWidget(
                        game: e.game,
                        eventType: eventStatistique.type,
                        nombre: e.nombre,
                        one: gameEventsStatistique.length == 1,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      )
    ]);
  }
}

class JoueurStatistiqueListTileWidget extends StatelessWidget {
  final EventStatistique eventStatistique;
  const JoueurStatistiqueListTileWidget(
      {super.key, required this.eventStatistique});

  String get getTitle => eventStatistique.type == EventType.but
      ? 'Buts'
      : eventStatistique.type == EventType.jaune
          ? 'Cartons jaunes'
          : eventStatistique.type == EventType.rouge
              ? 'Cartons Rouges'
              : '';

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      child: ListTile(
        leading: EventIconWidget(
          eventType: eventStatistique.type,
        ),
        title: Text(getTitle),
        trailing: Text(
          eventStatistique.nombre.toString(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class EventIconWidget extends StatelessWidget {
  final EventType? eventType;
  const EventIconWidget({super.key, required this.eventType});

  @override
  Widget build(BuildContext context) {
    return eventType == EventType.but
        ? Icon(Icons.sports_soccer)
        : (eventType == EventType.jaune
            ? CardWidget(isRed: false)
            : (eventType == EventType.rouge
                ? CardWidget(isRed: true)
                : SizedBox()));
  }
}

class GameJoueurStatWidget extends StatelessWidget {
  final Game game;
  final EventType? eventType;
  final int nombre;
  final bool one;
  const GameJoueurStatWidget(
      {super.key,
      required this.game,
      required this.eventType,
      required this.nombre,
      required this.one});
  String? get homeScore {
    if (game.score?.homeScorePenalty != null && game.score?.homeScore != null)
      return '${game.score?.homeScore} (${game.score?.homeScorePenalty})';
    if (game.score?.homeScore != null) return '${game.score?.homeScore}';
    return null;
  }

  String? get awayScore {
    if (game.score?.awayScorePenalty != null && game.score?.awayScore != null)
      return '${game.score?.awayScore} (${game.score?.awayScorePenalty})';
    if (game.score?.awayScore != null) return '${game.score?.awayScore}';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GameDetails(id: game.idGame)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 5, right: 5, top: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        height: 160,
        constraints: BoxConstraints(
          maxWidth: one ? MediaQuery.of(context).size.width : 220,
        ),
        child: PhysicalModel(
          borderRadius: BorderRadius.circular(4),
          elevation: 3,
          shadowColor: Colors.grey,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5.0),
                width: one ? MediaQuery.of(context).size.width * .80 : 150,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(game.niveau.nomNiveau.capitalize(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          )),
                      EquipeRowWidget(
                        score: homeScore ?? '',
                        participant: game.home,
                        eventType: eventType,
                        one: one,
                      ),
                      EquipeRowWidget(
                        score: awayScore ?? '',
                        participant: game.away,
                        eventType: eventType,
                        one: one,
                      ),
                      Text(
                        DateController.frDate(game.dateGame,
                            abbr: true, year: true),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    ]),
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 4,
                  runSpacing: 2,
                  children: [
                    ...List.generate(nombre,
                            (index) => EventIconWidget(eventType: eventType))
                        .expand(
                      (element) sync* {
                        yield element;
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EquipeRowWidget extends StatelessWidget {
  final EventType? eventType;
  final Participant participant;
  final String? score;
  final bool one;
  const EquipeRowWidget(
      {super.key,
      required this.eventType,
      required this.participant,
      required this.score,
      required this.one});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                  height: 30,
                  width: 30,
                  child: EquipeImageLogoWidget(url: participant.imageUrl)),
              SizedBox(width: 5),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: one ? MediaQuery.of(context).size.width * .50 : 50,
                ),
                child: Text(participant.nomEquipe,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )),
              )
            ],
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 30,
            maxWidth: 40,
          ),
          child: Center(child: Text(score ?? '')),
        )
      ],
    );
  }
}
