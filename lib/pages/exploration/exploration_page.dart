// ignore_for_file: must_be_immutable

import 'package:app/models/competition.dart';
import 'package:app/models/joueur.dart';
import 'package:app/models/participant.dart';
import 'package:app/pages/exploration/competition/all_section_widget.dart';
import 'package:app/pages/exploration/competition/competition_tile_widget.dart';
import 'package:app/pages/exploration/competition/favori_section_widget.dart';
import 'package:app/pages/exploration/competition/populaire_section_widget.dart';
import 'package:app/pages/exploration/equipe/equipe_all_section_widget.dart';
import 'package:app/pages/exploration/equipe/equipe_favori_section_widget.dart';
import 'package:app/pages/exploration/equipe/equipe_tile_widget.dart';
import 'package:app/pages/exploration/joueur/joueur_all_section_widget.dart';
import 'package:app/pages/exploration/joueur/joueur_favori_section_widget.dart';
import 'package:app/pages/exploration/search_field_widget.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Competition? competition;
Participant? participant;
Joueur? joueur;

class ExplorationPage extends StatelessWidget {
  final Function()? openDrawer;
  final bool checkPlatform;
  ExplorationPage({super.key, this.openDrawer, required this.checkPlatform});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: checkPlatform
            ? null
            : IconButton(
                onPressed: openDrawer,
                icon: Icon(Icons.menu),
              ),
        title: const Text('Exploration'),
        titleSpacing: 20,
      ),
      body: FutureBuilder(
          future: Future.wait([
            context.read<CompetitionProvider>().getCompetitions(),
            context.read<ParticipantProvider>().getParticipants(),
            context.read<JoueurProvider>().getJoueurs(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('erreur!'),
              );
            }

            return StatefulBuilder(builder: (context, setState) {
              return SingleChildScrollView(
                  child: competition != null && participant != null
                      ? JoueurListSectionWidget(
                          competition: competition!,
                          participant: participant!,
                          onBack: () {
                            setState(
                              () {
                                participant = null;
                              },
                            );
                          },
                          onDoubleBack: () {
                            setState(
                              () {
                                participant = null;
                                competition = null;
                              },
                            );
                          },
                        )
                      : competition != null
                          ? EquipeListSectionWidget(
                              competition: competition!,
                              onExplore: (part) {
                                setState(
                                  () {
                                    participant = part;
                                  },
                                );
                              },
                              onBack: () => setState(() {
                                competition = null;
                              }),
                            )
                          : CompetitionListSectionWidget(
                              onExplore: (comp) {
                                setState(
                                  () {
                                    competition = comp;
                                  },
                                );
                              },
                            ));
            });
          }),
    );
  }
}

class JoueurListSectionWidget extends StatelessWidget {
  final Competition competition;
  final Participant participant;
  final Function() onBack;
  final Function() onDoubleBack;

  JoueurListSectionWidget(
      {super.key,
      required this.competition,
      required this.onBack,
      required this.onDoubleBack,
      required this.participant});
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<JoueurProvider>(
      builder: (context, joueurProvider, child) {
        return Column(
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              child: CompetitionHorizontalTileWidget(
                  onBack: onDoubleBack, competition: competition, back: true),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              child: EquipeHorizontalTileWidget(
                  onBack: onBack, participant: participant, back: true),
            ),
            SearchFieldWidget(controller: controller),
            ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  return Column(
                    children: [
                      if (controller.text.isEmpty)
                        JoueurFavoriSectionWidget(
                          joueurProvider: joueurProvider,
                          participant: participant,
                        ),
                      JoueurAllSectionWidget(
                        joueurProvider: joueurProvider,
                        participant: participant,
                        controller: controller,
                      )
                    ],
                  );
                })
          ],
        );
      },
    );
  }
}

class EquipeListSectionWidget extends StatelessWidget {
  final Competition competition;
  final Function() onBack;
  final Function(Participant participant) onExplore;
  EquipeListSectionWidget(
      {super.key,
      required this.competition,
      required this.onBack,
      required this.onExplore});
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantProvider>(
      builder: (context, participantProvider, child) {
        return Column(
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              child: CompetitionHorizontalTileWidget(
                  onBack: onBack, competition: competition, back: true),
            ),
            SearchFieldWidget(controller: controller),
            ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  return Column(
                    children: [
                      if (controller.text.isEmpty)
                        EquipeFavoriSectionWidget(
                            participantProvider: participantProvider,
                            competition: competition,
                            onExplore: onExplore),
                      EquipeAllSectionWidget(
                          competition: competition,
                          participantProvider: participantProvider,
                          controller: controller,
                          onExplore: onExplore)
                    ],
                  );
                })
          ],
        );
      },
    );
  }
}

class CompetitionListSectionWidget extends StatelessWidget {
  final Function(Competition competition) onExplore;
  CompetitionListSectionWidget({super.key, required this.onExplore});
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<CompetitionProvider>(
        builder: (context, competitionProvider, child) {
      return Column(
        children: [
          SearchFieldWidget(controller: searchController),
          ListenableBuilder(
              listenable: searchController,
              builder: (context, _) {
                return Column(
                  children: [
                    if (searchController.text.isEmpty)
                      Column(
                        children: [
                          FavoriSectionWidget(
                              onExplore: onExplore,
                              competitionProvider: competitionProvider),
                          PopulaireSectionWidget(
                              onExplore: onExplore,
                              competitionProvider: competitionProvider),
                        ],
                      ),
                    AllSectionWidget(
                        onExplore: onExplore,
                        controller: searchController,
                        competitionProvider: competitionProvider),
                  ],
                );
              }),
        ],
      );
    });
  }
}
