import 'package:fscore/models/competition.dart';
import 'package:fscore/pages/exploration/competition/horizontal_list_widget.dart';
import 'package:fscore/providers/competition_provider.dart';
import 'package:fscore/widget/app/favori_title_widget.dart';
import 'package:flutter/material.dart';

class PopulaireSectionWidget extends StatelessWidget {
  final CompetitionProvider competitionProvider;
  final Function(Competition competition) onExplore;
  const PopulaireSectionWidget(
      {super.key, required this.competitionProvider, required this.onExplore});

  @override
  Widget build(BuildContext context) {
    final List<Competition> competitions = competitionProvider
        .collection.competitions
      ..sort((a, b) => ((b.rating ?? 0) - (a.rating ?? 0)).toInt());
    return competitions.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                FavoriTitleWidget(
                  margin: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                  title: 'Populaires',
                  icon: SizedBox(
                    width: 60,
                    height: 35,
                    child: Row(
                      children: [
                        Icon(Icons.star),
                        Icon(Icons.star),
                      ],
                    ),
                  ),
                ),
                HorizontalListWidget(
                    onExplore: onExplore,
                    competitions: competitions.take(5).toList()),
              ],
            ),
          );
  }
}
