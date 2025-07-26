import 'package:fscore/models/competition.dart';
import 'package:fscore/pages/exploration/competition/competition_tile_widget.dart';
import 'package:flutter/material.dart';

class HorizontalListWidget extends StatelessWidget {
  final List<Competition> competitions;
  final Function(Competition competition) onExplore;
  const HorizontalListWidget(
      {super.key, required this.competitions, required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: competitions
                .map((e) => CompetitionVerticalTileWidget(
                      onExplore: onExplore,
                      competition: e,
                    ))
                .expand((element) sync* {
              yield SizedBox(width: 10);
              yield element;
              yield SizedBox(width: 10);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
