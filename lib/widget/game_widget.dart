import 'package:app/controllers/competition/date.dart';
import 'package:app/core/enums/game_etat_enum.dart';
import 'package:app/core/enums/show_niveau_enum.dart';
import 'package:app/core/extension/string_extension.dart';
import 'package:app/pages/game/game_details.dart';
import 'package:app/models/game.dart';
import 'package:app/widget/logos/equipe_logo_widget.dart';
import 'package:flutter/material.dart';

class GameWidget extends StatelessWidget {
  final Game game;
  final ShowNiveauEnum showNiveauEnum;
  final bool showDate;
  final bool showEtat;
  const GameWidget(
      {super.key,
      required this.game,
      this.showDate = true,
      this.showNiveauEnum = ShowNiveauEnum.niveaux,
      this.showEtat = true});

  GameEtat get _etat => game.etat.etat;

  Color get _colorEtat {
    return switch (_etat) {
      GameEtat.direct || GameEtat.pause => Colors.green,
      GameEtat.reporte => Colors.red,
      _ => Colors.grey
    };
  }

  Color get _colorScore {
    return switch (_etat) {
      GameEtat.direct || GameEtat.pause => Colors.green,
      GameEtat.reporte => Colors.red,
      _ => Colors.black
    };
  }

  String get _niveauText {
    return switch (showNiveauEnum) {
      ShowNiveauEnum.niveaux => game.nomNiveau!,
      ShowNiveauEnum.competition => game.nomCompetition,
      ShowNiveauEnum.both => '${game.nomCompetition} ${game.nomNiveau}',
      ShowNiveauEnum.none => '',
    };
  }

  TextStyle get _styleScore {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: _colorScore,
    );
  }

  TextStyle get _styleEtat {
    return TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        backgroundColor: _colorEtat,
        color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GameDetails(id: game.idGame)));
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: Color.fromARGB(170, 158, 158, 158), width: 0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 50),
                  child: Text(
                    game.isPlayed && showEtat && _etat != GameEtat.avant
                        ? game.etat.text.substring(0, 3).toUpperCase()
                        : '',
                    style: _styleEtat,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 50),
                  child: Text(
                    _niveauText.capitalize(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 50),
                )
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: textTeam(game.home!, game.isHomeVictoire),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      game.scoreText,
                      style: _styleScore,
                    )),
                Expanded(child: textTeam(game.away!, game.isAwayVictoire)),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(),
                Text(
                  showDate && _etat != GameEtat.reporte
                      ? DateController.frDate(game.dateGame!, abbr: true)
                      : '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Text textTeam(String text, [bool bold = false]) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 15,
        fontWeight: bold ? FontWeight.w500 : FontWeight.normal,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class GameFullWidget extends StatelessWidget {
  final Game game;
  final bool showDate;
  final bool showEtat;
  final double? verticalMargin;
  final double? horizontalMargin;
  final double? elevation;

  const GameFullWidget({
    super.key,
    required this.game,
    this.showDate = true,
    this.showEtat = true,
    this.elevation,
    this.verticalMargin,
    this.horizontalMargin,
  });
  GameEtat get _etat => game.etat.etat;

  Color get _colorEtat {
    return switch (_etat) {
      GameEtat.direct || GameEtat.pause => Colors.green,
      GameEtat.reporte => Colors.red,
      _ => Colors.grey
    };
  }

  Color get _colorScore {
    return switch (_etat) {
      GameEtat.direct || GameEtat.pause => Colors.green,
      GameEtat.reporte => Colors.red,
      _ => Colors.black
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? 2,
      margin: EdgeInsets.symmetric(
          vertical: verticalMargin ?? 4, horizontal: horizontalMargin ?? 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      shadowColor: Colors.grey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GameDetails(id: game.idGame)));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: equipeWidget(game.home!, game.homeImage ?? ''),
              ),
              Container(
                constraints: BoxConstraints(minHeight: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text((game.nomNiveau ?? '').capitalize()),
                    Text(
                      game.scoreText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _colorScore,
                      ),
                    ),
                    Column(
                      children: [
                        if (showDate)
                          Text(
                            DateController.frDate(game.dateGame, abbr: true),
                            style: const TextStyle(fontSize: 12),
                          ),
                        if (game.isPlayed &&
                            showEtat &&
                            _etat != GameEtat.avant)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            color: _colorEtat,
                            child: Text(
                              game.etat.text.substring(0, 3).toUpperCase(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(child: equipeWidget(game.away!, game.awayImage ?? '')),
            ],
          ),
        ),
      ),
    );
  }

  Widget equipeWidget(String name, String imageUrl) => Column(
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: EquipeImageLogoWidget(
              url: imageUrl,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      );
}

class GameLessWidget extends StatelessWidget {
  final Game game;
  final bool showDate;
  final bool showEtat;

  const GameLessWidget(
      {super.key,
      required this.game,
      this.showDate = true,
      this.showEtat = true});
  GameEtat get _etat => game.etat.etat;

  Color get _colorEtat {
    return switch (_etat) {
      GameEtat.direct || GameEtat.pause => Colors.green,
      GameEtat.reporte => Colors.red,
      _ => Colors.grey
    };
  }

  Color get _colorScore {
    return switch (_etat) {
      GameEtat.direct || GameEtat.pause => Colors.green,
      GameEtat.reporte => Colors.red,
      _ => Colors.black
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      shadowColor: Colors.grey,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GameDetails(id: game.idGame)));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: equipeWidget(game.home!, game.homeImage ?? ''),
              ),
              Container(
                height: MediaQuery.sizeOf(context).height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text((game.nomNiveau ?? '').capitalize()),
                    Text(
                      game.scoreText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _colorScore,
                      ),
                    ),
                    Column(
                      children: [
                        if (showDate)
                          Text(
                            DateController.frDate(game.dateGame, abbr: true),
                            style: const TextStyle(fontSize: 12),
                          ),
                        if (game.isPlayed &&
                            showEtat &&
                            _etat != GameEtat.avant)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            color: _colorEtat,
                            child: Text(
                              game.etat.text.substring(0, 3).toUpperCase(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(child: equipeWidget(game.away!, game.awayImage ?? '')),
            ],
          ),
        ),
      ),
    );
  }

  Widget equipeWidget(String name, String imageUrl) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: EquipeImageLogoWidget(
              url: imageUrl,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      );
}
