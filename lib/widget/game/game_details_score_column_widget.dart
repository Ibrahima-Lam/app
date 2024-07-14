import 'package:app/controllers/competition/date.dart';
import 'package:app/core/enums/game_etat_enum.dart';
import 'package:app/models/game.dart';
import 'package:app/models/gameEvent.dart';
import 'package:flutter/material.dart';

class GameDetailsScoreColumnWidget extends StatelessWidget {
  final Game game;
  final TimerEvent? timer;
  const GameDetailsScoreColumnWidget(
      {super.key, required this.game, this.timer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: 135,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(),
          TextScore(
            '${game.scoreText}',
          ),
          Column(
            children: [
              Text(
                DateController.abbrDate(game.dateGame, year: true),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic),
              ),
              EtatWidget(
                etat: game.etat,
                timer: timer,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class EtatWidget extends StatelessWidget {
  GameEtatClass etat;
  final TimerEvent? timer;
  EtatWidget({super.key, required this.etat, this.timer});

  double _opacity = 1.0;

  Color get _colorEtat {
    return switch (etat.etat) {
      GameEtat.direct || GameEtat.pause => Colors.green,
      GameEtat.reporte || GameEtat.annule || GameEtat.arrete => Colors.red,
      _ => Colors.grey
    };
  }

  Stream<String> timeStream() async* {
    if (timer?.start == null) return;
    int start =
        DateTimeRange(start: DateTime.parse(timer!.start!), end: DateTime.now())
                .duration
                .inSeconds +
            ((timer?.initial ?? 0) + (timer!.retard ?? 0) + 1) * 60;
    int duration = (timer?.duration ?? 0 + (timer?.initial ?? 0)) * 60;
    int extra = (timer?.extra ?? 0) * 60;
    String except = duration != (45 * 60) && duration != (90 * 60)
        ? ' |${duration ~/ 60}'
        : '';
    for (int i = start; i <= duration + extra; i++) {
      if (i <= duration)
        yield '${i ~/ 60}\'$except';
      else
        yield '${duration ~/ 60} + ${extra ~/ 60}\'${except}';

      _opacity = i.isOdd ? 0.0 : 1.0;
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return etat.etat == GameEtat.avant
        ? const SizedBox(
            height: 30,
          )
        : Container(
            constraints: BoxConstraints(minWidth: 80),
            padding: EdgeInsets.all(2.0),
            margin: EdgeInsets.all(5.0),
            color: Colors.white,
            child: etat.etat != GameEtat.direct
                ? textWidget(etat.text)
                : StreamBuilder(
                    stream: timer != null && etat.etat == GameEtat.direct
                        ? timeStream()
                        : null,
                    builder: (context, snapshot) {
                      String text = etat.text;
                      if (snapshot.hasData) {
                        text = '${snapshot.data}';
                      }
                      if (snapshot.connectionState == ConnectionState.done ||
                          snapshot.connectionState == ConnectionState.waiting ||
                          !snapshot.hasData ||
                          snapshot.hasError) {
                        _opacity = 1.0;
                        text = etat.text;
                      }
                      return AnimatedOpacity(
                        opacity: _opacity,
                        duration: Duration(microseconds: 800),
                        child: textWidget(text),
                      );
                    }),
          );
  }

  Widget textWidget(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: _colorEtat, fontSize: 13, fontWeight: FontWeight.w400),
    );
  }
}

// ignore: must_be_immutable
class TextScore extends StatelessWidget {
  final String text;
  TextScore(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
