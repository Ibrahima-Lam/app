import 'package:app/models/joueur.dart';
import 'package:app/pages/equipe/equipe_details.dart';
import 'package:app/pages/joueur/widget_datails/joueur_match_list_widget.dart';
import 'package:app/pages/joueur/widget_datails/joueur_performance_widget.dart';
import 'package:app/pages/joueur/widget_datails/joueur_statistique_widget.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class JoueurDetails extends StatelessWidget {
  final String idJoueur;
  JoueurDetails({super.key, required this.idJoueur});

  late final Joueur joueur;

  Future<bool> _getJoueur(BuildContext context) async {
    joueur = await context.read<JoueurProvider>().getJoueursByid(idJoueur);
    return true;
  }

  bool favori = false;
  Set<String> tabs = {'Fiche', 'Match', 'Infos', 'Performance', 'Statistique'};

  Map<String, Widget> get tabBarViewWidget => {
        'match': JoueurMatchListWidget(idJoueur: idJoueur),
        'performance': JoueurPerformanceWidget(joueur: joueur),
        'statistique': JoueurStatistiqueWidget(joueur: joueur),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _getJoueur(context),
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

            return DefaultTabController(
              length: tabs.length,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      title: Text(
                        joueur.nomJoueur,
                      ),
                      forceElevated: innerBoxIsScrolled,
                      expandedHeight: 200.0,
                      pinned: true,
                      actions: [
                        StatefulBuilder(
                          builder: (context, setState) {
                            return IconButton(
                              onPressed: () {
                                setState(() => favori = !favori);
                              },
                              icon:
                                  Icon(favori ? Icons.star : Icons.star_border),
                            );
                          },
                        )
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                          background: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EquipeDetails(
                                                        id: joueur
                                                            .idParticipant)));
                                      },
                                      icon: Icon(Icons.safety_check)),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                CircleAvatar(
                                  radius: 40,
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                CircleAvatar(
                                  child: Icon(Icons.check_circle),
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                      bottom: TabBarWidget.build(
                          tabs: tabs
                              .map((e) => Tab(
                                    text: e,
                                  ))
                              .toList()),
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    for (String tab in tabs)
                      tabBarViewWidget[tab.toLowerCase()] ??
                          Center(
                            child: Text('Page vide!'),
                          ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
