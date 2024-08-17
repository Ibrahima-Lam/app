import 'package:app/models/competition.dart';
import 'package:app/pages/exploration/competition/competition_tile_widget.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/widget/app/favori_title_widget.dart';
import 'package:flutter/material.dart';

class AllSectionWidget extends StatelessWidget {
  final CompetitionProvider competitionProvider;
  final TextEditingController controller;
  final Function(Competition competition) onExplore;
  const AllSectionWidget(
      {super.key,
      required this.competitionProvider,
      required this.controller,
      required this.onExplore});

  @override
  Widget build(BuildContext context) {
    List<Competition> competitions = competitionProvider.collection.competitions
      ..sort((a, b) => ((b.rating ?? 0) - (a.rating ?? 0)).toInt());
    if (controller.text.isNotEmpty) {
      competitions = competitions
          .where((element) => element.nomCompetition
              .toUpperCase()
              .contains(controller.text.toUpperCase()))
          .toList();
    }
    return competitions.isEmpty
        ? Container(
            height: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(controller.text.isEmpty
                  ? 'Pas de compétition disponible!'
                  : 'Pas de correspondance!'),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                FavoriTitleWidget(
                  title: controller.text.isEmpty ? 'Tous' : "Recherche",
                  icon: SizedBox(
                    width: 75,
                    height: 35,
                    child: controller.text.isEmpty
                        ? Row(
                            children: [
                              Icon(Icons.star),
                              Icon(Icons.star),
                              Icon(Icons.star_border),
                            ],
                          )
                        : SizedBox(
                            width: 35, height: 35, child: Icon(Icons.search)),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: competitions
                          .map((e) => CompetitionHorizontalTileWidget(
                                competition: e,
                                onExplore: onExplore,
                              ))
                          .toList(),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
