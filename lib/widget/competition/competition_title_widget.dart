import 'package:app/core/enums/categorie_enum.dart';
import 'package:app/models/competition.dart';
import 'package:app/pages/competition/competition_details.dart';
import 'package:app/widget/app/favori_icon_widget.dart';
import 'package:app/widget/logos/competition_logo_image.dart';
import 'package:flutter/material.dart';

class CompetitionTitleWidget extends StatelessWidget {
  final Competition competition;
  const CompetitionTitleWidget({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CompetitionDetails(
                id: competition.codeEdition,
              ))),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        shadowColor: Colors.grey,
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 40,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 246, 237, 245),
                Colors.white,
                Color.fromARGB(255, 246, 237, 245),
              ]),
              borderRadius: BorderRadius.circular(4.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 40,
                        height: 40,
                        child: CompetitionImageLogoWidget(
                            url: competition.imageUrl)),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(
                        competition.nomCompetition,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.sizeOf(context).height,
                width: 60,
                child: Center(
                  child: PopupMenuButton(
                    padding: EdgeInsets.all(5),
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          child: FavoriIconWidget(
                              id: competition.codeEdition,
                              categorie: Categorie.competition)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
