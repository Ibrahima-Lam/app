import 'package:app/controllers/equipe/equipe_controller.dart';
import 'package:app/core/enums/event_type_enum.dart';
import 'package:app/models/event.dart';
import 'package:app/pages/joueur/joueur_details.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/widget/joueur_logo_widget.dart';
import 'package:app/widget/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompetitionStatistiqueWidget extends StatelessWidget {
  final String idEdition;
  const CompetitionStatistiqueWidget({super.key, required this.idEdition});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: null,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Erreur de chargement!'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Consumer2<GameEventListProvider, ParticipantProvider>(
          builder: (context, eventProvider, participantProvider, child) {
            final List<Event> events = eventProvider.events;

            final List<EventStatistique> buts = [];
            final List<EventStatistique> jaunes = [];
            final List<EventStatistique> rouges = [];
            for (var participant in participantProvider.participants
                .where((element) => element.idEdition == idEdition)
                .toList()) {
              final List<Event> evs = events
                  .where((element) =>
                      element.idParticipant == participant.idParticipant)
                  .toList();
              buts.addAll(
                  EquipeController.getEventStistique(evs, type: EventType.but));
              jaunes.addAll(EquipeController.getEventStistique(evs,
                  type: EventType.jaune));
              rouges.addAll(EquipeController.getEventStistique(evs,
                  type: EventType.rouge));
            }
            buts.sort((a, b) => b.nombre - a.nombre);
            jaunes.sort((a, b) => b.nombre - a.nombre);
            rouges.sort((a, b) => b.nombre - a.nombre);
            return buts.isEmpty && rouges.isEmpty && jaunes.isEmpty
                ? Center(
                    child: Text(
                        'Pas de statistique disponible pour cette competition!'),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        if (buts.isNotEmpty)
                          CompetitionStatistiquesSectionWidget(
                              title: 'Buts', statistiques: buts),
                        if (jaunes.isNotEmpty)
                          CompetitionStatistiquesSectionWidget(
                              title: 'Cartons Jaunes', statistiques: jaunes),
                        if (rouges.isNotEmpty)
                          CompetitionStatistiquesSectionWidget(
                              title: 'Cartons Rouges', statistiques: rouges),
                      ],
                    ),
                  );
          },
        );
      },
    );
  }
}

class CompetitionStatistiquesSectionWidget extends StatefulWidget {
  final String title;
  final List<EventStatistique> statistiques;
  CompetitionStatistiquesSectionWidget(
      {super.key, required this.title, required this.statistiques});

  @override
  State<CompetitionStatistiquesSectionWidget> createState() =>
      _CompetitionStatistiquesSectionWidgetState();
}

class _CompetitionStatistiquesSectionWidgetState
    extends State<CompetitionStatistiquesSectionWidget> {
  final int nombre = 10;

  bool expended = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Column(
        children: [
          SectionTitleWidget(title: widget.title),
          ...widget.statistiques
              .take(expended ? 100 : 10)
              .map((e) => CompetitionStatistiquesListTileWidget(reducer: e))
              .toList(),
          if (widget.statistiques.length > nombre)
            OutlinedButton(
                onPressed: () => setState(() {
                      expended = !expended;
                    }),
                child: Text(expended ? 'Voir moins' : 'Voir plus'))
        ],
      ),
    );
  }
}

class CompetitionStatistiquesListTileWidget extends StatelessWidget {
  final EventStatistique reducer;
  const CompetitionStatistiquesListTileWidget(
      {super.key, required this.reducer});

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
      leading: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        height: 50,
        width: 50,
        child: JoueurImageLogoWidget(url: reducer.imageUrl),
      ),
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
