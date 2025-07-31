import 'package:fscore/core/enums/categorie_enum.dart';
import 'package:fscore/models/api/fixture.dart';
import 'package:fscore/widget/app/favori_icon_widget.dart';
import 'package:fscore/widget/logos/competition_logo_image.dart';
import 'package:flutter/material.dart';

class LeagueTileWidget extends StatelessWidget {
  final League league;
  const LeagueTileWidget({super.key, required this.league});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.pushNamed(
        context,
        '/league_details',
        arguments: league,
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        shadowColor: Colors.grey,
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        child: Container(
          width: MediaQuery.of(context).size.width,
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
                        child: CompetitionImageLogoWidget(url: league.logo)),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(
                        league.name ?? '',
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
                height: MediaQuery.of(context).size.height,
                width: 60,
                child: Center(
                  child: PopupMenuButton(
                    padding: EdgeInsets.all(5),
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          child: FavoriIconWidget(
                              id: league.id.toString(),
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
