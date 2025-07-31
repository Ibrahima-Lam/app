import 'package:flutter/material.dart';
import 'package:fscore/controllers/competition/date.dart';
import 'package:fscore/core/enums/game_etat_enum.dart';
import 'package:fscore/models/api/fixture.dart';
import 'package:fscore/widget/logos/equipe_logo_widget.dart';

class FixtureWidget extends StatelessWidget {
  final Fixture fixture;
  const FixtureWidget({super.key, required this.fixture});

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
            Navigator.pushNamed(
              context,
              '/fixture_details',
              arguments: fixture,
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FixtureTeamWidget(
                  team: fixture.teams.home,
                ),
              ),
              FixtureScoreWidget(fixture: fixture),
              Expanded(child: FixtureTeamWidget(team: fixture.teams.away)),
            ],
          ),
        ),
      ),
    );
  }
}

class FixtureTeamWidget extends StatelessWidget {
  final Team team;
  final double? size;
  final double? fontSize;
  final double? espace;
  const FixtureTeamWidget({
    super.key,
    required this.team,
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
                url: team.logo,
              ),
            ),
          ],
        ),
        SizedBox(
          height: espace,
        ),
        Text(
          team.name,
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

class FixtureScoreWidget extends StatefulWidget {
  final Fixture fixture;

  const FixtureScoreWidget({
    super.key,
    required this.fixture,
  });

  @override
  State<FixtureScoreWidget> createState() => _FixtureScoreWidgetState();
}

class _FixtureScoreWidgetState extends State<FixtureScoreWidget>
    with TickerProviderStateMixin {
  Color get _statutColor {
    var statut = widget.fixture.fixture.status?.status;
    if (statut == GameEtat.direct || statut == GameEtat.pause)
      return Colors.green;
    if (statut == GameEtat.annule || statut == GameEtat.arrete)
      return Colors.red;
    if (statut == GameEtat.avant) return Colors.white;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            (widget.fixture.league?.round ?? ''),
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          Text(
            widget.fixture.score?.score ??
                widget.fixture.goals?.score ??
                widget.fixture.fixture.time ??
                '',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: null),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateController.frDate(widget.fixture.fixture.date,
                      abbr: true),
                  style: const TextStyle(fontSize: 12),
                ),
                Container(
                  color: _statutColor,
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Text(
                    widget.fixture.fixture.status?.short ?? '',
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
