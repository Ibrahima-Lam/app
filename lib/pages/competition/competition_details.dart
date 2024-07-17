import 'package:app/core/enums/categorie_enum.dart';
import 'package:app/core/enums/competition_type.dart';
import 'package:app/core/params/categorie/categorie_params.dart';
import 'package:app/models/competition.dart';
import 'package:app/pages/competition/widget_details/arbitre_list_widget.dart';
import 'package:app/pages/competition/widget_details/classement_list_widget.dart';
import 'package:app/pages/competition/widget_details/competition_coach_list_widget.dart';
import 'package:app/pages/competition/widget_details/competition_fiche_list_widget.dart';
import 'package:app/pages/competition/widget_details/competition_statistique_widget.dart';
import 'package:app/pages/competition/widget_details/equipe_list_widget.dart';
import 'package:app/pages/competition/widget_details/games_list_widget.dart';
import 'package:app/widget/app/favori_icon_widget.dart';
import 'package:app/widget/logos/competition_logo_image.dart';
import 'package:app/widget_pages/infos_list_widget.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/widget/skelton/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompetitionDetails extends StatefulWidget {
  final String id;
  const CompetitionDetails({super.key, required this.id});

  @override
  State<CompetitionDetails> createState() => _CompetitionDetailsState();
}

class _CompetitionDetailsState extends State<CompetitionDetails>
    with TickerProviderStateMixin {
  late Competition competition;
  List<String> tabs = [];
  bool favori = false;
  List<String> tabBarString(CompetitionType competitionType) {
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
      'Arbitres'
    ];
  }

  List<Widget> tabBarViewChildren(List<String> tabs) {
    List<Widget> widgets = [];
    for (String tab in tabs) {
      switch (tab.toUpperCase().substring(0, 3)) {
        case 'MAT':
          widgets.add(MatchsWidget(competition: competition));
          break;
        case 'CLA':
          widgets.add(ClassementListWidget(
            codeEdition: competition.codeEdition,
          ));
          break;
        case 'INF':
          widgets.add(InfosListWiget(
            categorieParams:
                CategorieParams(idEdition: competition.codeEdition),
          ));
          break;
        case 'EQU':
          widgets.add(
            EquipeListWidget(
              competition: competition,
            ),
          );
          break;
        case 'STA':
          widgets.add(
            CompetitionStatistiqueWidget(
              idEdition: competition.codeEdition,
            ),
          );
          break;
        case 'FIC':
          widgets.add(
            CompetitionFicheListWidget(
              idEdition: competition.codeEdition,
            ),
          );
          break;
        case 'ARB':
          widgets.add(
            ArbitreListWidget(
              idEdition: competition.codeEdition,
            ),
          );
          break;
        case 'ENT':
          widgets.add(
            CompetitionCoachListWidget(
              idEdition: competition.codeEdition,
            ),
          );
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
    return FutureBuilder(
        future: context.read<CompetitionProvider>().getCompetitions(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('erreur!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Consumer<CompetitionProvider>(
              builder: (context, competitionProvider, child) {
            competition =
                competitionProvider.collection.getElementAt(widget.id);
            tabs = tabBarString(competition.type.type);
            return DefaultTabController(
              length: tabs.length,
              child: Scaffold(
                body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        title: Text(
                          competition.nomCompetition,
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
                              id: competition.codeEdition,
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
                                        url: competition.imageUrl ?? '',
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
                        bottom: TabBarWidget.build(
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
        });
  }
}
