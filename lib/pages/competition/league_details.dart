import 'package:fscore/core/enums/categorie_enum.dart';
import 'package:fscore/core/enums/competition_type.dart';
import 'package:fscore/models/api/fixture.dart';
import 'package:fscore/providers/fixture_provider.dart';
import 'package:fscore/widget/app/favori_icon_widget.dart';
import 'package:fscore/widget/logos/competition_logo_image.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:fscore/widget/skelton/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeagueDetails extends StatefulWidget {
  final League league;
  const LeagueDetails({super.key, required this.league});

  @override
  State<LeagueDetails> createState() => _LeagueDetailsState();
}

class _LeagueDetailsState extends State<LeagueDetails>
    with TickerProviderStateMixin {
  List<String> tabs = [];
  bool favori = false;
  bool checkUser = false;
  List<String> tabBarString(CompetitionType competitionType, bool checkUser) {
    return [
      'Fiche',
      'Match',
      if (competitionType
          case CompetitionType.championnat || CompetitionType.coupe)
        'Classement',
      'Infos',
      'Statistique',
      'Equipes',
      'Entraineurs',
      'Arbitres',
      if (checkUser) 'Paramettre',
      if (checkUser) 'Formulaire',
      if (checkUser) 'Groupe',
      if (checkUser) 'Team',
      if (checkUser) 'Regroupement',
    ];
  }

  List<Widget> tabBarViewChildren(List<String> tabs) {
    List<Widget> widgets = [];
    for (String tab in tabs) {
      switch (tab.toUpperCase().substring(0, 3)) {
        case 'MAT':
          widgets.add(Center(child: Text('Matchs')));
          break;
        case 'CLA':
          widgets.add(Center(child: Text('Classement')));
          break;
        case 'INF':
          widgets.add(Center(child: Text('Infos')));
          break;
        case 'EQU':
          widgets.add(Center(child: Text('Equipes')));
          break;
        case 'STA':
          widgets.add(Center(child: Text('Statistique')));
          break;

        case 'FIC':
          widgets.add(Center(child: Text('Fiche')));
          break;
        case 'ARB':
          widgets.add(Center(child: Text('Arbitres')));
          break;
        case 'ENT':
          widgets.add(Center(child: Text('Entraineurs')));
          break;
        case 'PAR':
          widgets.add(Center(child: Text('Parametres')));
          break;
        case 'FOR':
          widgets.add(Center(child: Text('Formulaire')));

          break;
        case 'GRO':
          widgets.add(Center(child: Text('Groupes')));
          break;
        case 'TEA':
          widgets.add(Center(child: Text('Team')));
          break;
        case 'REG':
          widgets.add(Center(child: Text('Regroupement')));
          break;
        default:
          widgets.add(const Center(
            child: Text('Page vide!'),
          ));
      }
    }
    return widgets;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: FutureBuilder(
          future: null,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('erreur!'),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return Consumer<FixtureProvider>(
                builder: (context, fixtureProvider, child) {
              tabs = tabBarString(CompetitionType.amicale, false);
              return DefaultTabController(
                length: tabs.length,
                initialIndex: 0,
                child: Scaffold(
                  body: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          title: Text(
                            widget.league.name ?? '',
                            style: TextStyle(fontSize: 18),
                          ),
                          centerTitle: true,
                          pinned: true,
                          expandedHeight: 180,
                          leading: IconButton(
                            icon: const Icon(Icons.navigate_before),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          actions: [
                            FavoriIconWidget(
                                id: widget.league.id.toString(),
                                categorie: Categorie.competition)
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        child: Icon(Icons.local_grocery_store),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        width: 80,
                                        height: 80,
                                        child: CompetitionImageLogoWidget(
                                          url: widget.league.logo,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      CircleAvatar(
                                        radius: 25,
                                        child: Icon(
                                            Icons.assignment_turned_in_rounded),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          bottom: TabBarWidget.of(context).build(
                              tabs: tabs
                                  .map((e) => Tab(
                                        text: e,
                                      ))
                                  .toList()),
                        )
                      ];
                    },
                    body: TabBarView(
                      children: tabBarViewChildren(tabs),
                    ),
                  ),
                ),
              );
            });
          }),
    );
  }
}
