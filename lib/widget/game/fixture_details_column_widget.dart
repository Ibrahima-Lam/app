import 'package:fscore/models/api/fixture.dart';
import 'package:fscore/providers/statistique_provider.dart';
import 'package:fscore/widget/game/card_and_num_widget.dart';
import 'package:fscore/widget/logos/equipe_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FixtureDetailsColumnWidget extends StatelessWidget {
  final bool isHome;
  final Team team;
  final League? league;
  const FixtureDetailsColumnWidget(
      {super.key,
      required this.isHome,
      required this.team,
      required this.league});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatistiqueProvider>(builder: (context, val, child) {
      double value = 0;
      int _red = 0;
      int _yellow = 0;
      int? _valuePourcent;

      return Container(
        constraints: BoxConstraints(minWidth: 120),
        child: Stack(
          alignment: isHome ? Alignment.centerLeft : Alignment.centerRight,
          children: [
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                          '/team_details',
                          arguments: {'team': team, 'league': league}),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: EquipeImageLogoWidget(
                              url: team.logo,
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              if (value >= 1 || value < 0) {
                                value = 0;
                              }
                              final Color color = (value >= 0.5
                                  ? const Color.fromARGB(255, 5, 148, 10)
                                  : const Color.fromARGB(255, 215, 21, 7));
                              return CircularProgressIndicator(
                                backgroundColor:
                                    isHome ? (color) : Colors.white,
                                value: isHome ? 1 - value : value,
                                strokeAlign: 10,
                                strokeWidth: 2,
                                valueColor: isHome
                                    ? AlwaysStoppedAnimation(Colors.white)
                                    : AlwaysStoppedAnimation(color),
                              );
                            },
                          )
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    team.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                right: 3,
                left: 3,
              ),
              child: CardAndStatWidget(
                  isHome: isHome,
                  red: _red,
                  yellow: _yellow,
                  pourcent: _valuePourcent),
            )
          ],
        ),
      );
    });
  }
}

class CardAndStatWidget extends StatelessWidget {
  final int red;
  final int yellow;
  final int? pourcent;
  final bool isHome;
  const CardAndStatWidget(
      {super.key,
      this.red = 0,
      this.yellow = 0,
      this.pourcent,
      required this.isHome});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      constraints: BoxConstraints(maxWidth: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: !isHome ? TextDirection.ltr : TextDirection.rtl,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 10,
                ),
                child: yellow > 0
                    ? CardAndNumberWidget(
                        nombre: yellow,
                        yellow: true,
                      )
                    : null,
              ),
              SizedBox(
                width: 2,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 10,
                ),
                child: red > 0
                    ? CardAndNumberWidget(
                        nombre: red,
                        yellow: false,
                      )
                    : null,
              ),
            ],
          ),
          Text(
            pourcent != null && (pourcent ?? 0) > 0 && (pourcent ?? 0) < 100
                ? '$pourcent%'
                : '',
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
