import 'package:app/models/competition.dart';
import 'package:app/pages/competition/competition_details.dart';
import 'package:app/pages/exploration/rating_widget.dart';
import 'package:app/widget/logos/competition_logo_image.dart';
import 'package:flutter/material.dart';

abstract class CompetitionSupTileWidget extends StatelessWidget {
  final Competition competition;
  const CompetitionSupTileWidget({super.key, required this.competition});

  void onTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CompetitionDetails(id: competition.codeEdition)));
  }

  void onExplored(BuildContext context) {}
  void onBacked(BuildContext context) {}
}

class CompetitionHorizontalTileWidget extends CompetitionSupTileWidget {
  final bool back;
  final Function()? onBack;
  final Function(Competition competition)? onExplore;
  const CompetitionHorizontalTileWidget(
      {super.key,
      required super.competition,
      this.back = false,
      this.onBack,
      this.onExplore});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(context),
      leading: SizedBox(
        width: 50,
        height: 50,
        child: CompetitionImageLogoWidget(url: competition.imageUrl),
      ),
      title: Text(
        competition.nomCompetition,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: const TextStyle(),
      ),
      subtitle: RatingWidget(rating: competition.rating, centered: false),
      trailing: back
          ? IconButton(
              onPressed: onBack != null ? () => onBack!() : null,
              icon: Icon(
                Icons.clear,
                color: Colors.red,
              ))
          : IconButton(
              onPressed:
                  onExplore != null ? () => onExplore!(competition) : null,
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.green,
              )),
    );
  }
}

class CompetitionVerticalTileWidget extends CompetitionSupTileWidget {
  final Function(Competition competition)? onExplore;
  const CompetitionVerticalTileWidget(
      {super.key, required super.competition, this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: () => onTap(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            width: 130,
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CompetitionImageLogoWidget(url: competition.imageUrl),
                ),
                Text(
                  competition.nomCompetition,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
                RatingWidget(rating: competition.rating),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: onExplore != null ? () => onExplore!(competition) : null,
          icon: Icon(Icons.exit_to_app, size: 20),
          color: Colors.green,
        )
      ],
    );
  }
}
