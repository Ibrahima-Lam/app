import 'package:fscore/core/params/categorie/categorie_params.dart';
import 'package:fscore/models/arbitres/arbitre.dart';
import 'package:fscore/models/competition.dart';
import 'package:fscore/pages/arbitre/widget_details/arbitre_fiche_list_widget.dart';
import 'package:fscore/pages/arbitre/widget_details/arbitre_game_list_widget.dart';
import 'package:fscore/pages/competition/competition_details.dart';
import 'package:fscore/providers/arbitre_provider.dart';
import 'package:fscore/providers/competition_provider.dart';
import 'package:fscore/widget/logos/arbitre_logo_widget.dart';
import 'package:fscore/widget/logos/competition_logo_image.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:fscore/widget/skelton/tab_bar_widget.dart';
import 'package:fscore/widget_pages/infos_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArbitreDetails extends StatelessWidget {
  final String id;
  ArbitreDetails({super.key, required this.id});
  late final Arbitre arbitre;
  late final Competition competition;
  final Set<String> tabs = {'Fiche', 'Matchs', 'Infos'};
  Map<String, Widget> get tabBarViewWidget => {
        'fiche': ArbitreFicheListWidget(arbitre: arbitre),
        'matchs': ArbitreGameListWidget(idArbitre: id),
        'infos': InfosListWiget(categorieParams: CategorieParams(idArbitre: id))
      };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: FutureBuilder(
        future: null,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('erreur!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Consumer2<ArbitreProvider, CompetitionProvider>(
            builder: (context, arb, comp, child) {
              arbitre = arb.getArbitre(id)!;
              competition = comp.collection.getElementAt(arbitre.idEdition);
              return Scaffold(
                body: DefaultTabController(
                  length: tabs.length,
                  child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            centerTitle: true,
                            title: Text(
                              arbitre.nomArbitre,
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  arbitre.role == 'assistant'
                                      ? Icons.flag
                                      : arbitre.role == 'principale'
                                          ? Icons.sports
                                          : arbitre.role == 'var'
                                              ? Icons.tv
                                              : Icons
                                                  .settings_backup_restore_outlined,
                                ),
                              ),
                            ],
                            expandedHeight: 180,
                            pinned: true,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 35),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      CompetitionDetails(
                                                          id: competition
                                                              .codeEdition))),
                                          child: SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: CompetitionImageLogoWidget(
                                                url:
                                                    competition.imageUrl ?? ''),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: ArbitreImageLogoWidget(
                                            url: arbitre.imageUrl,
                                          ),
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
                          )
                        ];
                      },
                      body: TabBarView(
                          children: tabs
                              .map((e) =>
                                  tabBarViewWidget[e.toLowerCase()] ??
                                  const Center(
                                    child: Text('Page vide!'),
                                  ))
                              .toList())),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
