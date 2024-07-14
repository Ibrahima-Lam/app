import 'package:app/controllers/competition/date.dart';
import 'package:app/core/enums/game_etat_enum.dart';
import 'package:app/core/enums/show_niveau_enum.dart';
import 'package:app/core/extension/string_extension.dart';
import 'package:app/models/event.dart';
import 'package:app/pages/game/game_details.dart';
import 'package:app/models/game.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/widget/game/card_and_num_widget.dart';
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

  GameEtat get etat => game.etat.etat;

  Color get colorEtat {
    return switch (etat) {
      GameEtat.direct || GameEtat.pause => Colors.green,
      GameEtat.reporte || GameEtat.annule || GameEtat.arrete => Colors.red,
      _ => Colors.grey
    };
  }

  Color get colorScore {
    return switch (etat) {
      GameEtat.direct || GameEtat.pause => Colors.green,
      GameEtat.reporte || GameEtat.annule || GameEtat.arrete => Colors.red,
      _ => Colors.black
    };
  }

//  todo
  String get _niveauText {
    return switch (showNiveauEnum) {
      ShowNiveauEnum.niveaux => game.niveau.nomNiveau,
      ShowNiveauEnum.both => '${game.niveau.nomNiveau}',
      ShowNiveauEnum.none || _ => '',
    };
  }

  TextStyle get _styleScore {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: colorScore,
    );
  }

  TextStyle get _styleEtat {
    return TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        backgroundColor: colorEtat,
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
                    game.isPlayed && showEtat && etat != GameEtat.avant
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
                  child: textTeam(game.home.nomEquipe, game.isHomeVictoire),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      game.scoreText,
                      style: _styleScore,
                    )),
                Expanded(
                    child: textTeam(game.away.nomEquipe, game.isAwayVictoire)),
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
                  showDate && etat != GameEtat.reporte
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

class GameFullWidget extends GameLessWidget {
  final double? verticalMargin;
  final double? horizontalMargin;
  final double? elevation;

  const GameFullWidget({
    super.key,
    this.elevation,
    this.verticalMargin,
    this.horizontalMargin,
    required super.game,
    super.showDate = true,
    super.showEtat = true,
    required super.gameEventListProvider,
  });

  final double _size = 60;
  final double _fontSize = 14;
  final double _space = 8;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? 2,
      margin: EdgeInsets.symmetric(
          vertical: verticalMargin ?? 4, horizontal: horizontalMargin ?? 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      shadowColor: Colors.grey,
      child: Container(
        height: 120,
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
                child: GameEquipeWidget(
                  name: game.home.nomEquipe,
                  red: homeRed,
                  imageUrl: game.home.imageUrl ?? '',
                  size: _size,
                  espace: _space,
                  fontSize: _fontSize,
                ),
              ),
              GameScoreWiget(
                game: game,
                showDate: showDate,
                showEtat: showEtat,
                colorScore: colorScore,
                etat: etat,
                colorEtat: colorEtat,
                fontSize: 18,
              ),
              Expanded(
                  child: GameEquipeWidget(
                name: game.away.nomEquipe,
                red: awayRed,
                imageUrl: game.away.imageUrl ?? '',
                size: _size,
                espace: _space,
                fontSize: _fontSize,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class GameLessWidget extends GameWidget {
  final GameEventListProvider gameEventListProvider;

  const GameLessWidget({
    super.key,
    required super.game,
    super.showDate = true,
    super.showEtat = true,
    required this.gameEventListProvider,
  });

  int get homeRed => gameEventListProvider
      .getEquipeGameEvent(idGame: game.idGame, idParticipant: game.idHome)
      .whereType<CardEvent>()
      .where((element) => element.isRed)
      .length;
  int get awayRed => gameEventListProvider
      .getEquipeGameEvent(idGame: game.idGame, idParticipant: game.idAway)
      .whereType<CardEvent>()
      .where((element) => element.isRed)
      .length;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      shadowColor: Colors.grey,
      child: Container(
        height: 85,
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
                child: GameEquipeWidget(
                    name: game.home.nomEquipe,
                    red: homeRed,
                    imageUrl: game.home.imageUrl ?? ''),
              ),
              GameScoreWiget(
                  game: game,
                  showDate: showDate,
                  showEtat: showEtat,
                  colorScore: colorScore,
                  etat: etat,
                  colorEtat: colorEtat),
              Expanded(
                  child: GameEquipeWidget(
                      name: game.away.nomEquipe,
                      red: awayRed,
                      imageUrl: game.away.imageUrl ?? '')),
            ],
          ),
        ),
      ),
    );
  }
}

class GameScoreWiget extends StatelessWidget {
  final Game game;
  final bool showDate;
  final bool showEtat;
  final Color? colorScore;
  final Color? colorEtat;
  final GameEtat etat;
  final double? fontSize;
  const GameScoreWiget({
    super.key,
    required this.game,
    required this.showDate,
    required this.showEtat,
    required this.colorScore,
    required this.etat,
    required this.colorEtat,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            (game.niveau.nomNiveau).capitalize(),
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          Text(
            game.scoreText,
            style: TextStyle(
              fontSize: fontSize ?? 16,
              fontWeight: FontWeight.bold,
              color: colorScore,
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showDate)
                  Text(
                    DateController.frDate(game.dateGame, abbr: true),
                    style: const TextStyle(fontSize: 12),
                  ),
                if (game.isPlayed && showEtat && etat != GameEtat.avant)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.0),
                    color: colorEtat,
                    child: Text(
                      game.etat.text.substring(0, 3).toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class GameEquipeWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final int? red;
  final double? size;
  final double? fontSize;
  final double? espace;
  const GameEquipeWidget({
    super.key,
    required this.name,
    required this.red,
    required this.imageUrl,
    this.size = 40,
    this.espace = 5,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            SizedBox(
              height: size,
              width: size,
              child: EquipeImageLogoWidget(
                url: imageUrl,
              ),
            ),
            if (red != null && (red ?? 0) > 0)
              CardAndNumberWidget(
                nombre: red ?? 0,
                yellow: false,
                showOneNumber: false,
                textColor: Colors.white,
                height: 14,
                width: 10,
                fontSize: 10,
              )
          ],
        ),
        SizedBox(
          height: espace,
        ),
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
