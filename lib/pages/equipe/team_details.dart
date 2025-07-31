// ignore_for_file: must_be_immutable

import 'package:fscore/core/enums/categorie_enum.dart';
import 'package:fscore/models/api/fixture.dart';
import 'package:fscore/pages/equipe/widget_details/joueur_delegate_search_widget.dart';
import 'package:fscore/providers/paramettre_provider.dart';
import 'package:fscore/widget/app/favori_icon_widget.dart';
import 'package:fscore/widget/logos/competition_logo_image.dart';
import 'package:fscore/widget/logos/equipe_logo_widget.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:fscore/widget/skelton/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamDetails extends StatelessWidget {
  final Team team;
  final League league;
  TeamDetails({super.key, required this.team, required this.league});

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
        'match': Center(child: Text('Matchs')),
        'classement': Center(child: Text('Classement')),
        'effectif': Center(child: Text('Effectif')),
        'infos': Center(child: Text('Infos')),
        'statistique': Center(child: Text('Statistiques')),
        'fiche': Center(child: Text('Fiche')),
      };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: FutureBuilder(
          future: null,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                  child: Text('Erreur de chargement!'),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Consumer<ParamettreProvider>(
                builder: (context, paramettreProvider, child) {
              return DefaultTabController(
                length: tabs.length,
                child: Scaffold(
                  body: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          centerTitle: true,
                          pinned: true,
                          expandedHeight: 180,
                          leading: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.navigate_before),
                          ),
                          title: Text(
                            team.name,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          actions: [
                            FavoriIconWidget(
                                id: team.id.toString(),
                                categorie: Categorie.equipe),
                            IconButton(
                                onPressed: () {
                                  showSearch(
                                      context: context,
                                      delegate: JoueurDelegateSearch(
                                          idParticipant: team.id.toString()));
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
                                  const SizedBox(height: 35),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/league_details',
                                                arguments: league),
                                        child: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: CompetitionImageLogoWidget(
                                              url: league.logo ?? ''),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      EquipeImageLogoWidget(
                                        height: 65,
                                        width: 65,
                                        url: team.logo,
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
                          bottom: TabBarWidget.of(context).build(
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
                  ),
                ),
              );
            });
          }),
    );
  }
}
