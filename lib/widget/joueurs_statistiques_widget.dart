import 'package:app/controllers/equipe/equipe_controller.dart';
import 'package:app/core/enums/event_type_enum.dart';
import 'package:app/models/event.dart';
import 'package:app/pages/joueur/joueur_details.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/composition_events_widget.dart';
import 'package:app/widget/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoueursStatistiquesWidget extends StatelessWidget {
  final String idParticipant;
  const JoueursStatistiquesWidget({super.key, required this.idParticipant});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context
          .read<GameEventListProvider>()
          .getEquipeEvents(idParticipant: idParticipant),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Erreur de chargement!'),
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
            final List<Event> events = value.events
                .where((element) => element.idParticipant == idParticipant)
                .toList();
            final List<EventStatistique> buts =
                EquipeController.getEventStistique(events, type: EventType.but);
            final List<EventStatistique> jaunes =
                EquipeController.getEventStistique(events,
                    type: EventType.jaune);
            final List<EventStatistique> rouges =
                EquipeController.getEventStistique(events,
                    type: EventType.rouge);
            return events.isEmpty
                ? Center(
                    child: Text(
                        'Pas de statistique disponible pour cette equipe!'),
                  )
                : ListView(
                    children: [
                      if (buts.isNotEmpty)
                        JoueursStatistiquesSectionWidget(
                            title: 'Buts', statistiques: buts),
                      if (jaunes.isNotEmpty)
                        JoueursStatistiquesSectionWidget(
                            title: 'Cartons Jaunes', statistiques: jaunes),
                      if (rouges.isNotEmpty)
                        JoueursStatistiquesSectionWidget(
                            title: 'Cartons Rouges', statistiques: rouges),
                    ],
                  );
          },
        );
      },
    );
  }
}

class JoueursStatistiquesSectionWidget extends StatelessWidget {
  final String title;
  final List<EventStatistique> statistiques;
  const JoueursStatistiquesSectionWidget(
      {super.key, required this.title, required this.statistiques});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Column(
        children: [
          SectionTitleWidget(title: title),
          ...statistiques
              .map((e) => JoueursStatistiquesListTileWidget(reducer: e))
              .toList()
        ],
      ),
    );
  }
}

class JoueursStatistiquesListTileWidget extends StatelessWidget {
  final EventStatistique reducer;
  const JoueursStatistiquesListTileWidget({super.key, required this.reducer});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final bool check =
            await context.read<JoueurProvider>().checkId(reducer.id);
        if (check)
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => JoueurDetails(idJoueur: reducer.id)));
      },
      leading: PersonWidget(),
      title: Text(reducer.nom),
      trailing: Text(
        reducer.nombre.toString(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
