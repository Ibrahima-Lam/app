// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:app/collection/game_event_list_collection.dart';
import 'package:app/core/constants/event/kEvent.dart';
import 'package:app/models/event.dart';
import 'package:app/models/game.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/widget/event_widget.dart';
import 'package:app/widget_pages/event_list_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EvenementWidget extends StatelessWidget {
  final Game game;
  const EvenementWidget({super.key, required this.game});
  void _onDoubleTap(BuildContext context, Event event) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EventListForm(
        event: event,
        isNew: false,
      ),
    ));

    context.read<GameEventListProvider>().setEvent(event);
  }

  void _addEvent(BuildContext context,
      {required String idGame, required String idParticipant}) async {
    Event? event;
    final String? val = await showModalBottomSheet(
      context: context,
      builder: (context) => ModalWidget(),
    );

    if (val == 'but') {
      event = kGoalEvent.copyWith(idGame: idGame, idParticipant: idParticipant);
    } else if (val == 'rouge') {
      event =
          kRedCardEvent.copyWith(idGame: idGame, idParticipant: idParticipant);
    } else if (val == 'jaune') {
      event = kYellowCardEvent.copyWith(
          idGame: idGame, idParticipant: idParticipant);
    } else if (val == 'changement') {
      event =
          kRemplEvent.copyWith(idGame: idGame, idParticipant: idParticipant);
    }
    if (event != null) {
      final Event? ev = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EventListForm(
          event: event!,
          isNew: true,
        ),
      ));
      if (ev == null) return null;
      context.read<GameEventListProvider>().addEvent(event);
    }
  }

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

          return Consumer<GameEventListProvider>(
            builder: (context, value, child) {
              final GameEventListSousCollection gameEventListSousCollection =
                  GameEventListSousCollection(
                game: game,
                goals: value.getGameGoalsEvents(
                    idParticipant: game.idAway, idGame: game.idGame),
                yellowCards: value.getGameCardEvents(idGame: game.idGame),
                redCards:
                    value.getGameCardEvents(idGame: game.idGame, isRed: true),
                substitutions: value.getGameSubstitutionEvents(
                  idParticipant: game.idAway,
                  idGame: game.idGame,
                ),
              );
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ListView(
                  children: [
                    if (gameEventListSousCollection.goals.isNotEmpty)
                      EventSectionWidget(
                          onDoubleTap: (p0) => _onDoubleTap(context, p0),
                          events: gameEventListSousCollection.goals,
                          game: game,
                          title: 'Buts'),
                    if (gameEventListSousCollection.yellowCards.isNotEmpty)
                      EventSectionWidget(
                          onDoubleTap: (p0) => _onDoubleTap(context, p0),
                          events: gameEventListSousCollection.yellowCards,
                          game: game,
                          title: 'Cartons Jaunes'),
                    if (gameEventListSousCollection.redCards.isNotEmpty)
                      EventSectionWidget(
                          onDoubleTap: (p0) => _onDoubleTap(context, p0),
                          events: gameEventListSousCollection.redCards,
                          game: game,
                          title: 'Cartons Rouges'),
                    if (gameEventListSousCollection.substitutions.isNotEmpty)
                      EventSectionWidget(
                          onDoubleTap: (p0) => _onDoubleTap(context, p0),
                          events: gameEventListSousCollection.substitutions,
                          game: game,
                          title: 'Changements'),
                    Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                _addEvent(context,
                                    idGame: game.idGame,
                                    idParticipant: game.idHome);
                              },
                              child: Text('Ajouter')),
                          OutlinedButton(
                              onPressed: () {
                                _addEvent(context,
                                    idGame: game.idGame,
                                    idParticipant: game.idAway);
                              },
                              child: Text('Ajouter')),
                        ],
                      ),
                    ),
                    if (value.events.isEmpty)
                      Container(
                        height: 200.0,
                        child: Center(
                          child: Text('Pas evenement disponible !'),
                        ),
                      )
                  ],
                ),
              );
            },
          );
        });
  }
}

class EventSectionWidget extends StatelessWidget {
  final List<Event> events;
  final Game game;
  final Function(Event)? onDoubleTap;
  final String title;
  const EventSectionWidget(
      {super.key,
      required this.events,
      required this.game,
      this.onDoubleTap,
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
          ...events
              .map((e) =>
                  EventWidget(event: e, onDoubleTap: onDoubleTap, game: game))
              .toList()
        ],
      ),
    );
  }
}

class ModalWidget extends StatelessWidget {
  const ModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 20),
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, 'but');
                  },
                  child: Text('But')),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, 'rouge');
                  },
                  child: Text('Carton Rouge')),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, 'jaune');
                  },
                  child: Text('Carton jaune')),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, 'changement');
                  },
                  child: Text('changement')),
            ],
          ),
        );
      },
    );
  }
}
