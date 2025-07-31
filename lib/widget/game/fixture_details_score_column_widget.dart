import 'package:fscore/controllers/competition/date.dart';
import 'package:fscore/core/enums/game_etat_enum.dart';
import 'package:fscore/models/api/fixture.dart';
import 'package:fscore/models/gameEvent.dart';
import 'package:flutter/material.dart';

class FixtureDetailsScoreColumnWidget extends StatelessWidget {
  final Fixture fixture;
  const FixtureDetailsScoreColumnWidget({super.key, required this.fixture});

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
            '${fixture.score?.score ?? ''}',
          ),
          Column(
            children: [
              Text(
                DateController.abbrDate(fixture.fixture.date, year: true),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic),
              ),
              EtatWidget(
                status: fixture.fixture.status ?? Status(),
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
  Status status;
  final TimerEvent? timer;
  EtatWidget({super.key, required this.status, this.timer});

  Color get _colorEtat {
    return switch (status.status) {
      GameEtat.direct || GameEtat.pause => Colors.green,
      GameEtat.reporte || GameEtat.annule || GameEtat.arrete => Colors.red,
      _ => Colors.grey
    };
  }

  @override
  Widget build(BuildContext context) {
    return status.status == GameEtat.avant
        ? const SizedBox(
            height: 30,
          )
        : Container(
            constraints: BoxConstraints(minWidth: 80),
            padding: EdgeInsets.all(2.0),
            margin: EdgeInsets.all(5.0),
            color: Colors.white,
            child: textWidget(status.short ?? ''));
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
