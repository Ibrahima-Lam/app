// ignore_for_file: invalid_use_of_visible_for_testing_member, must_be_immutable

import 'package:fscore/collection/game_event_list_collection.dart';
import 'package:fscore/controllers/competition/date.dart';
import 'package:fscore/core/constants/event/kEvent.dart';
import 'package:fscore/core/enums/event_type_enum.dart';
import 'package:fscore/models/event.dart';
import 'package:fscore/models/game.dart';
import 'package:fscore/providers/game_event_list_provider.dart';
import 'package:fscore/widget/events/event_widget.dart';
import 'package:fscore/widget/app/section_title_widget.dart';
import 'package:fscore/widget/modals/confirm_dialog_widget.dart';
import 'package:fscore/widget_pages/event_list_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class EvenementWidget extends StatelessWidget {
  final Game game;
  final bool checkUser;
  EvenementWidget({super.key, required this.game, required this.checkUser});

  void _onDoubleTap(BuildContext context, Event event) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EventListForm(
        event: event,
        isNew: false,
      ),
    ));

    context.read<GameEventListProvider>().editEvent(event.idEvent, event);
  }

  void _addEvent(BuildContext context,
      {required String idGame, required String idParticipant}) async {
    Event? event;
    final String? val = await showModalBottomSheet(
      context: context,
      builder: (context) => ModalWidget(),
    );

    if (val == 'but') {
      event = kGoalEvent.copyWith(
          idEvent: 'G${DateController.dateCollapsed}',
          idGame: idGame,
          idParticipant: idParticipant);
    } else if (val == 'rouge') {
      event = kRedCardEvent.copyWith(
          isRed: true,
          idEvent: 'C${DateController.dateCollapsed}',
          idGame: idGame,
          idParticipant: idParticipant);
    } else if (val == 'jaune') {
      event = kYellowCardEvent.copyWith(
          isRed: false,
          idEvent: 'C${DateController.dateCollapsed}',
          idGame: idGame,
          idParticipant: idParticipant);
    } else if (val == 'changement') {
      event = kRemplEvent.copyWith(
          idEvent: 'R${DateController.dateCollapsed}',
          idGame: idGame,
          idParticipant: idParticipant);
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
              child: CircularProgressIndicator(),
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (gameEventListSousCollection.goals.isNotEmpty)
                        EventSectionWidget(
                            checkUser: checkUser,
                            onDoubleTap: checkUser
                                ? (p0) => _onDoubleTap(context, p0)
                                : null,
                            events: gameEventListSousCollection.goals,
                            game: game,
                            title: 'Buts'),
                      if (gameEventListSousCollection.yellowCards.isNotEmpty)
                        EventSectionWidget(
                            checkUser: checkUser,
                            onDoubleTap: checkUser
                                ? (p0) => _onDoubleTap(context, p0)
                                : null,
                            events: gameEventListSousCollection.yellowCards,
                            game: game,
                            title: 'Cartons Jaunes'),
                      if (gameEventListSousCollection.redCards.isNotEmpty)
                        EventSectionWidget(
                            checkUser: checkUser,
                            onDoubleTap: checkUser
                                ? (p0) => _onDoubleTap(context, p0)
                                : null,
                            events: gameEventListSousCollection.redCards,
                            game: game,
                            title: 'Cartons Rouges'),
                      if (gameEventListSousCollection.substitutions.isNotEmpty)
                        EventSectionWidget(
                            checkUser: checkUser,
                            onDoubleTap: checkUser
                                ? (p0) => _onDoubleTap(context, p0)
                                : null,
                            events: gameEventListSousCollection.substitutions,
                            game: game,
                            title: 'Changements'),
                      if (checkUser)
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
                      if (value.events
                          .where((element) => element.idGame == game.idGame)
                          .isEmpty)
                        Container(
                          height: 200.0,
                          child: Center(
                            child: Text(
                                'Pas d\'evenement disponible pour ce match !'),
                          ),
                        )
                    ],
                  ),
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
  final bool checkUser;
  const EventSectionWidget(
      {super.key,
      required this.events,
      required this.game,
      this.onDoubleTap,
      required this.title,
      required this.checkUser});

  void _onDelete(BuildContext context, Event event) async {
    final bool? confirm = await showDialog(
        context: context,
        builder: (context) => ConfirmDialogWidget(
              title: 'Supprimer ?',
              content: 'Voulez vous vraiment supprimer cet evenement ?',
            ));
    if (confirm != null && confirm) {
      final EventType type = event is GoalEvent
          ? EventType.but
          : event is CardEvent
              ? event.isRed
                  ? EventType.rouge
                  : EventType.jaune
              : EventType.changement;
      context.read<GameEventListProvider>().deleteEvent(event.idEvent, type);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Column(
        children: [
          SectionTitleWidget(title: title),
          ...events
              .map((e) => EventTileWidget(
                  enable: checkUser,
                  event: e,
                  onDoubleTap: onDoubleTap,
                  onDelete: (p0) => _onDelete(context, p0),
                  game: game))
              .toList()
        ],
      ),
    );
  }
}

class EventTileWidget extends StatelessWidget {
  final Event event;
  final Function(Event)? onDoubleTap;
  final Function(Event) onDelete;
  final Game game;
  final bool enable;
  const EventTileWidget(
      {super.key,
      required this.event,
      this.onDoubleTap,
      required this.onDelete,
      required this.game,
      required this.enable});

  @override
  Widget build(BuildContext context) {
    return Slidable(
        enabled: enable,
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: (p0) => onDelete(event),
              icon: Icons.delete,
              foregroundColor: Colors.red,
            )
          ],
        ),
        child: EventWidget(event: event, onDoubleTap: onDoubleTap, game: game));
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
