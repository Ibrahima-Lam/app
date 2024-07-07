import 'package:app/core/params/categorie/categorie_params.dart';
import 'package:app/models/arbitres/arbitre.dart';
import 'package:app/models/competition.dart';
import 'package:app/pages/arbitre/widget_details/arbitre_fiche_list_widget.dart';
import 'package:app/pages/arbitre/widget_details/arbitre_game_list_widget.dart';
import 'package:app/pages/competition/competition_details.dart';
import 'package:app/providers/arbitre_provider.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/widget/arbitre_logo_widget.dart';
import 'package:app/widget/competition_logo_image.dart';
import 'package:app/widget/tab_bar_widget.dart';
import 'package:app/widget_pages/infos_list_widget.dart';
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
    return FutureBuilder(
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
                      print(innerBoxIsScrolled);
                      return [
                        SliverAppBar(
                          title: Text(arbitre.nomArbitre),
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
                          expandedHeight: 200,
                          pinned: true,
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
                                      SizedBox(
                                        height: 90,
                                        width: 90,
                                        child: ArbitreImageLogoWidget(
                                          noColor: true,
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
                          bottom: TabBarWidget.build(
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
    );
  }
}
