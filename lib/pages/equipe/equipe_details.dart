import 'package:app/collection/competition_collection.dart';
import 'package:app/controllers/equipe/equipe_controller.dart';
import 'package:app/models/competition.dart';
import 'package:app/models/joueur.dart';
import 'package:app/models/participant.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/widget/joueur_widget.dart';
import 'package:app/widget/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EquipeDetails extends StatefulWidget {
  final String id;
  const EquipeDetails({super.key, required this.id});

  @override
  State<EquipeDetails> createState() => _EquipeDetailsState();
}

class _EquipeDetailsState extends State<EquipeDetails> {
  List<String> tabs = ['Match', 'Classement', 'infos', 'Joueur', 'Competition'];
  late final Participant participant;
  late final Competition competition;
  Future<bool> _getEquipe(BuildContext context) async {
    participant =
        await context.read<ParticipantProvider>().getParticipant(widget.id);
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
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              );
            }

            return Consumer(builder: (context, val, child) {
              return DefaultTabController(
                  length: tabs.length,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          pinned: true,
                          expandedHeight: 250,
                          leading: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.navigate_before),
                          ),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          title: Text(participant.nomEquipe!),
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        child: Text(EquipeController.abbr(
                                            participant.nomEquipe!)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        padding: const EdgeInsets.all(2),
                                        child: FittedBox(
                                          child: Text(
                                            participant.libelleEquipe!,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                backgroundColor: Colors.white,
                                                color: Colors.blue),
                                          ),
                                        ),
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
                          .map((e) => JoueurListWidget(
                              idParticipant: participant.idParticipant!))
                          .toList(),
                    ),
                  ));
            });
          }),
    );
  }
}

class JoueurListWidget extends StatelessWidget {
  final String idParticipant;
  const JoueurListWidget({super.key, required this.idParticipant});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context
            .read<JoueurProvider>()
            .getJoueursBy(idParticipant: idParticipant),
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

          return Consumer<JoueurProvider>(builder: (context, val, child) {
            List<Joueur> joueurs = snapshot.data ?? [];
            return ListView.builder(
              itemCount: joueurs.length,
              itemBuilder: (context, index) {
                final Joueur joueur = joueurs[index];
                return JoueurListTileWidget(joueur: joueur);
              },
            );
          });
        });
  }
}
