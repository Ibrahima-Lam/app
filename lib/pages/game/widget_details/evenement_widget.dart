import 'package:app/collection/game_event_list_collection.dart';
import 'package:app/models/Event.dart';
import 'package:app/models/game.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/widget/event_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EvenementWidget extends StatelessWidget {
  final Game game;
  const EvenementWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context
          .read<GameEventListProvider>()
          .getGameEvents(idGame: game.idGame),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('erreur!'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        }
        final GameEventListCollection gameEventListCollection = snapshot.data!;
        final GameEventListSousCollection gameEventListSousCollection =
            GameEventListSousCollection(
          game: game,
          goals: gameEventListCollection.getGameGoalsEvents(
              idParticipant: game.idAway, idGame: game.idGame),
          yellowCards: gameEventListCollection.getGameCardEvents(
              idParticipant: game.idHome, idGame: game.idGame),
          redCards: gameEventListCollection.getGameCardEvents(
              idParticipant: game.idAway, idGame: game.idGame, isRed: true),
          substitutions: gameEventListCollection.getGameSubstitutionEvents(
            idParticipant: game.idAway,
            idGame: game.idGame,
          ),
        );
        return Consumer<GameEventListProvider>(
          builder: (context, value, child) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: ListView(
                children: [
                  EventSectionWidget(
                      events: gameEventListSousCollection.goals,
                      game: game,
                      title: 'Buts'),
                  EventSectionWidget(
                      events: gameEventListSousCollection.yellowCards,
                      game: game,
                      title: 'Cartons Jaunes'),
                  EventSectionWidget(
                      events: gameEventListSousCollection.redCards,
                      game: game,
                      title: 'Cartons Rouges'),
                  EventSectionWidget(
                      events: gameEventListSousCollection.substitutions,
                      game: game,
                      title: 'Changements'),
                  Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                            onPressed: () {}, child: Text('Ajouter')),
                        OutlinedButton(
                            onPressed: () {}, child: Text('Ajouter')),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class EventSectionWidget extends StatelessWidget {
  final List<Event> events;
  final Game game;
  final String title;
  const EventSectionWidget(
      {super.key,
      required this.events,
      required this.game,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Column(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black, width: 0.5))),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...events.map((e) => EventWidget(event: e, game: game)).toList()
        ],
      ),
    );
  }
}
