import 'package:app/controllers/joueur/joueur_controller.dart';
import 'package:app/core/enums/event_type_enum.dart';
import 'package:app/models/event.dart';
import 'package:app/models/joueur.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/widget/events/composition_events_widget.dart';
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
        return Consumer<GameEventListProvider>(
          builder: (context, value, child) {
            List<EventStatistique> eventStatistiques =
                JoueurController.getJoueurStatistique(joueur,
                        events: value.events)
                    .where((element) => element.nombre > 0)
                    .toList();
            return SingleChildScrollView(
              child: Column(
                children: [
                  JoueurStatistiqueSectionWidget(
                    eventStatistiques: eventStatistiques,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class JoueurStatistiqueSectionWidget extends StatelessWidget {
  final List<EventStatistique> eventStatistiques;
  const JoueurStatistiqueSectionWidget(
      {super.key, required this.eventStatistiques});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: eventStatistiques.isEmpty
          ? Center(
              child: Text('Pas de  statistique disponible pour ce joueur!'),
            )
          : Column(
              children: eventStatistiques
                  .map((e) => JoueurStatistiqueListTileWidget(
                        eventStatistique: e,
                      ))
                  .toList(),
            ),
    );
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
    return ListTile(
      shape: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
          top: BorderSide(color: Colors.grey, width: 0.5)),
      leading: eventStatistique.type == EventType.but
          ? Icon(Icons.sports_soccer)
          : eventStatistique.type == EventType.jaune
              ? CardWidget()
              : eventStatistique.type == EventType.rouge
                  ? CardWidget(isRed: true)
                  : null,
      title: Text(getTitle),
      trailing: Text(
        eventStatistique.nombre.toString(),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
