import 'package:fscore/models/competition.dart';
import 'package:fscore/pages/exploration/competition/horizontal_list_widget.dart';
import 'package:fscore/providers/competition_provider.dart';
import 'package:fscore/providers/favori_provider.dart';
import 'package:fscore/widget/app/favori_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriSectionWidget extends StatelessWidget {
  final CompetitionProvider competitionProvider;
  final Function(Competition competition) onExplore;
  const FavoriSectionWidget(
      {super.key, required this.competitionProvider, required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriProvider>(
      builder: (context, favoriProvider, child) {
        final List<String> favoris = favoriProvider.competitions;
        final List<Competition> competitions = competitionProvider
            .collection.competitions
            .where((element) => favoris.any((e) => e == element.codeEdition))
            .toList();
        return favoris.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    FavoriTitleWidget(
                      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                    ),
                    HorizontalListWidget(
                      competitions: competitions,
                      onExplore: onExplore,
                    ),
                  ],
                ),
              );
      },
    );
  }
}
