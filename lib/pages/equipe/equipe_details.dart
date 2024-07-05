// ignore_for_file: must_be_immutable

import 'package:app/collection/competition_collection.dart';
import 'package:app/models/competition.dart';
import 'package:app/models/participant.dart';
import 'package:app/pages/competition/competition_details.dart';
import 'package:app/pages/equipe/widget_details/equipe_fiche_list_widget.dart';
import 'package:app/pages/equipe/widget_details/game_list_widget.dart';
import 'package:app/pages/equipe/widget_details/joueur_delegate_search_widget.dart';
import 'package:app/pages/equipe/widget_details/effectif_widget.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/widget/classement_widget.dart';
import 'package:app/pages/equipe/widget_details/equipe_statistiques_widget.dart';
import 'package:app/widget/competition_logo_image.dart';
import 'package:app/widget/equipe_logo_widget.dart';
import 'package:app/widget_pages/infos_list_widget.dart';
import 'package:app/widget/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EquipeDetails extends StatelessWidget {
  final String id;
  EquipeDetails({super.key, required this.id});
  bool favori = false;
  static String CLASSEMENT = 'Classement';
  final Set<String> tabs = {
    'Fiche',
    'Match',
    CLASSEMENT,
    'infos',
    'Effectif',
    'Statistique',
  };

  Map<String, Widget> get tabBarViewWidgets => {
        'match': GameListWidget(idParticipant: id),
        'classement':
            ClassementWiget.equipe(title: '', idParticipant: id, idTarget: id),
        'effectif': EffectifWidget(idParticipant: id),
        'infos': InfosListWiget(idPartcipant: id),
        'statistique': EquipeStatistiquesWidget(idParticipant: id),
        'fiche': EquipeFicheListWidget(participant: participant),
      };

  late final Participant participant;

  late final Competition competition;

  Future<bool> _getEquipe(BuildContext context) async {
    participant = await context.read<ParticipantProvider>().getParticipant(id);
    CompetitionCollection competitionCollection =
        await context.read<CompetitionProvider>().getCompetitions();
    competition = competitionCollection.getElementAt(participant.codeEdition!);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _getEquipe(context),
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

            return Consumer(builder: (context, val, child) {
              if (!competition.hasClassement) {
                tabs.remove(CLASSEMENT);
              }

              return DefaultTabController(
                  length: tabs.length,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          pinned: true,
                          expandedHeight: 200,
                          leading: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.navigate_before),
                          ),
                          title: Text(participant.nomEquipe),
                          actions: [
                            StatefulBuilder(
                              builder: (context, setState) => IconButton(
                                onPressed: () {
                                  setState(() => favori = !favori);
                                },
                                icon: Icon(
                                    favori ? Icons.star : Icons.star_outline),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  showSearch(
                                      context: context,
                                      delegate: JoueurDelegateSearch(
                                          idParticipant: id));
                                },
                                icon: Icon(Icons.search)),
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 50),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CompetitionDetails(
                                                        id: competition
                                                            .codeEdition!))),
                                        child: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: CompetitionImageLogoWidget(
                                              url: competition.imageUrl ?? ''),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      EquipeImageLogoWidget(
                                        noColor: true,
                                        url: participant.imageUrl,
                                        radius: 40,
                                        size: 40,
                                      ),
                                      const SizedBox(width: 20),
                                      CircleAvatar(
                                        radius: 20,
                                        child: Icon(Icons.house),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          bottom: TabBarWidget.build(
                              tabs: tabs.map((e) => Tab(text: e)).toList()),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: tabs
                          .map((e) =>
                              tabBarViewWidgets[e.toLowerCase()] ??
                              Center(
                                child: Text('page vide !'),
                              ))
                          .toList(),
                    ),
                  ));
            });
          }),
    );
  }
}
