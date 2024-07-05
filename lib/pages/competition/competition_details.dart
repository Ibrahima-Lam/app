import 'package:app/core/enums/competition_type.dart';
import 'package:app/models/competition.dart';
import 'package:app/pages/competition/widget_details/classement_list_widget.dart';
import 'package:app/pages/competition/widget_details/competition_fiche_list_widget.dart';
import 'package:app/pages/competition/widget_details/competition_statistique_widget.dart';
import 'package:app/pages/competition/widget_details/equipe_list_widget.dart';
import 'package:app/pages/competition/widget_details/games_list_widget.dart';
import 'package:app/widget/competition_logo_image.dart';
import 'package:app/widget_pages/infos_list_widget.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/widget/tab_bar_widget.dart';
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

  List<String> tabBarString(CompetitionType competitionType) {
    if (competitionType
        case CompetitionType.championnat || CompetitionType.coupe) {
      return [
        'Fiche',
        'Match',
        'Classement',
        'Infos',
        'Statistique',
        'Equipes',
        'Arbitres'
      ];
    }
    if (competitionType == CompetitionType.finale) {
      return ['Fiche', 'Match', 'Infos', 'Statistique', 'Equipes', 'Arbitres'];
    }

    return ['Fiche', 'Match', 'Infos'];
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
            codeEdition: competition.codeEdition!,
          ));
          break;
        case 'INF':
          widgets.add(InfosListWiget());
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
              idEdition: competition.codeEdition!,
            ),
          );
          break;
        case 'FIC':
          widgets.add(
            CompetitionFicheListWidget(
              idEdition: competition.codeEdition!,
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

          competition = snapshot.data!.getElementAt(widget.id);
          tabs = tabBarString(competition.type.type);
          return DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      title: Text(competition.nomCompetition!),
                      pinned: true,
                      expandedHeight: 250,
                      leading: IconButton(
                        icon: const Icon(Icons.navigate_before),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    child: Icon(Icons.local_grocery_store),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 90,
                                    height: 90,
                                    child: CompetitionImageLogoWidget(
                                      url: competition.imageUrl ?? '',
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CircleAvatar(
                                    radius: 25,
                                    child: Icon(
                                        Icons.assignment_turned_in_rounded),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Edition ${competition.anneeEdition!}',
                                style: const TextStyle(
                                    color: Colors.blue,
                                    backgroundColor: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
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
  }
}
