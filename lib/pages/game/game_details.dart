import 'package:app/collection/competition_collection.dart';
import 'package:app/collection/game_collection.dart';
import 'package:app/controllers/competition/date.dart';
import 'package:app/core/class/abbreviable.dart';
import 'package:app/core/enums/game_etat_enum.dart';
import 'package:app/models/competition.dart';
import 'package:app/models/game.dart';
import 'package:app/models/gameEvent.dart';
import 'package:app/pages/competition/competition_details.dart';
import 'package:app/pages/equipe/equipe_details.dart';
import 'package:app/pages/game/widget_details/composition_widget.dart';
import 'package:app/pages/game/widget_details/evenement_widget.dart';
import 'package:app/pages/game/widget_details/statistique_widget.dart';
import 'package:app/widget/classement_widget.dart';
import 'package:app/pages/game/widget_details/journee_list_widget.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/custom_delegate_search.dart';
import 'package:app/widget/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/core/extension/string_extension.dart';

final ValueNotifier<double> notifier = ValueNotifier(0.0);

class GameDetails extends StatefulWidget {
  final String id;
  const GameDetails({super.key, required this.id});
  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails>
    with SingleTickerProviderStateMixin, Abbreviable {
  late Game game;
  late Competition competition;
  late final ScrollController _scrollController;
  final ValueNotifier<bool> _isExpended = ValueNotifier(true);

  Future<bool> _getData(BuildContext context) async {
    GameCollection _gameColletion =
        await context.read<GameProvider>().getGames();
    game = _gameColletion.getElementAt(widget.id);
    String? codeEdition = game.codeEdition;
    if (codeEdition == null) {
      throw Exception('Erreur competition!');
    }
    CompetitionCollection _competitionColletion =
        await context.read<CompetitionProvider>().getCompetitions();
    competition = _competitionColletion.getElementAt(codeEdition);
    return true;
  }

  (List<String>, int) tabBarString(GameEtat gameEtat,
      {bool composition = false, bool classement = false}) {
    int initial = 0;
    if (gameEtat case GameEtat.pause || GameEtat.direct || GameEtat.termine) {
      initial = composition && classement
          ? 5
          : composition
              ? 3
              : 2;
      return (
        [
          'Journée',
          if (classement) 'Classement',
          'Avant Match',
          if (composition) 'Composition',
          'Evenement',
          'Statistique',
        ],
        initial
      );
    }
    initial = composition && classement
        ? 3
        : composition
            ? 2
            : 1;
    return (
      [
        'Journée',
        if (classement) 'Classement',
        'Avant Match',
        if (composition) 'Composition'
      ],
      initial
    );
  }

  List<Widget> tabBarViewChildren(List<String> tabs) {
    List<Widget> widgets = [];
    for (String tab in tabs) {
      switch (tab.toUpperCase().substring(0, 3)) {
        case 'JOU':
          widgets.add(JourneeWidget(game: game));
          break;
        case 'CLA':
          widgets.add(ClassementWiget(
              title: 'Groupe ${game.nomGroupe}', idGroupe: game.idGroupe!));
          break;
        case 'COM':
          widgets.add(CompositionWidget(
            game: game,
          ));
          break;
        case 'EVE':
          widgets.add(EvenementWidget(
            game: game,
          ));
        case 'STA':
          widgets.add(StatistiqueWidget(
            game: game,
          ));
          break;

        default:
          widgets.add(const Center(
            child: Text('Page vide!'),
          ));
      }
    }
    return widgets;
  }

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset > 150 && _isExpended.value) {
          _isExpended.value = false;
        }
        if (_scrollController.offset < 150 && !_isExpended.value) {
          _isExpended.value = true;
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getData(context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('erreur!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          }
          var (tabs, initial) = tabBarString(game.etat.etat,
              composition: true, classement: game.codePhase == 'grp');
          return DefaultTabController(
            initialIndex: initial,
            length: tabs.length,
            child: Scaffold(
              body: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    pinned: true,
                    expandedHeight: 280,
                    leading: IconButton(
                      icon: const Icon(Icons.navigate_before),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {
                            showSearch(
                                context: context,
                                delegate: CustomDelegateSearch());
                          },
                          icon: Icon(Icons.search))
                    ],
                    centerTitle: true,
                    title: ValueListenableBuilder(
                        valueListenable: _isExpended,
                        builder: (context, val, child) {
                          return AnimatedOpacity(
                            opacity: _isExpended.value ? 0.0 : 1.0,
                            duration: Duration(milliseconds: 300),
                            child: Text(
                              '${abbr(game.home!)} ${game.score} ${abbr(game.away.toString())}',
                              style: const TextStyle(fontSize: 17),
                            ),
                          );
                        }),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => CompetitionDetails(
                                          id: game.codeEdition!),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${competition.nomCompetition}. ',
                                      style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      '${game.nomNiveau!.capitalize()}',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(),
                          Consumer<GameProvider>(
                            builder: (context, value, child) {
                              GameEvent gameEvent = value.getEvent(game);
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ColumnWidget(
                                    text: game.home!,
                                    id: game.idHome,
                                    isHome: true,
                                    event: gameEvent.homeEvent,
                                  ),
                                  ColumnScoreWidget(
                                    game: game,
                                    timer: gameEvent.timer,
                                  ),
                                  ColumnWidget(
                                    text: game.away!,
                                    id: game.idAway,
                                    isHome: false,
                                    event: gameEvent.awayEvent,
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                    bottom: TabBarWidget.build(
                      tabs: [
                        for (final tab in tabs)
                          Tab(
                            text: tab,
                          )
                      ],
                    ),
                  ),
                ],
                body: TabBarView(
                  children: tabBarViewChildren(tabs),
                ),
              ),
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: 'stat',
                    onPressed: () {
                      if (notifier.value <= 1.0 && notifier.value >= 0) {
                        notifier.value = notifier.value + 0.05;
                      } else
                        notifier.value = 0.0;
                      context.read<GameProvider>().changePourcent(
                          game.idGame,
                          (notifier.value == 0.0 || notifier.value >= 1)
                              ? null
                              : notifier.value,
                          timerEvent: TimerEvent(
                              start: DateTime.now().toString(),
                              duration: 45,
                              extra: 3,
                              retard: 0,
                              initial: 0));
                    },
                    child: Text('%'),
                  ),
                  FloatingActionButton(
                    heroTag: 'etat',
                    onPressed: () {
                      context.read<GameProvider>().changeEtat(
                          id: game.idGame,
                          etat: game.etat.etat == GameEtat.direct
                              ? 'termine'
                              : 'direct');
                    },
                    child: Text('Etat'),
                  ),
                  FloatingActionButton(
                    heroTag: 'score',
                    onPressed: () {
                      context
                          .read<GameProvider>()
                          .changeScore(id: game.idGame, hs: 2, as: 0);
                    },
                    child: Text('+/-'),
                  ),
                  FloatingActionButton(
                    heroTag: 'card',
                    onPressed: () {
                      context.read<GameProvider>().changeCard(game.idGame);
                    },
                    child: Text('Card'),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class ColumnScoreWidget extends StatelessWidget {
  final Game game;
  final TimerEvent? timer;
  const ColumnScoreWidget({super.key, required this.game, this.timer});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(),
          TextScore(
            '${game.score}',
          ),
          Column(
            children: [
              Text(
                DateController.abbrDate(game.dateGame!, year: true),
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
      GameEtat.reporte => Colors.red,
      _ => Colors.grey
    };
  }

  Stream<String> timeStream() async* {
    int start =
        DateTimeRange(start: DateTime.parse(timer!.start), end: DateTime.now())
                .duration
                .inSeconds +
            (timer!.initial + timer!.retard + 1) * 60;
    int duration = (timer!.duration + timer!.initial) * 60;
    int extra = (timer!.extra) * 60;
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

  Widget textWidget(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: _colorEtat, fontSize: 13, fontWeight: FontWeight.w400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !etat.started
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
                : StreamBuilder<String>(
                    stream: timer != null && etat.etat == GameEtat.direct
                        ? timeStream()
                        : null,
                    builder: (context, snapshot) {
                      String text = etat.text;
                      if (snapshot.hasData &&
                          snapshot.connectionState != ConnectionState.done) {
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

class ColumnWidget extends StatelessWidget {
  final String text;
  final String id;
  final bool isHome;

  final EventStream event;
  const ColumnWidget(
      {super.key,
      required this.text,
      required this.id,
      required this.isHome,
      required this.event});

  int? get _valuePourcent =>
      event.pourcent != null ? (event.pourcent! * 100).toInt() : null;
  int get _yellow => event.yellowCard;
  int get _red => event.redCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 120),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            child: isHome
                ? CardAndStatWidget(
                    red: _red, yellow: _yellow, pourcent: _valuePourcent)
                : null,
          ),
          Container(
            height: 100,
            constraints: BoxConstraints(maxWidth: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EquipeDetails(id: id))),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          child: Icon(Icons.people),
                        ),
                        Builder(
                          builder: (context) {
                            double? value = event.pourcent;
                            if (value != null) {
                              if (value >= 1) {
                                value = 0;
                              }
                            } else
                              value = 0;

                            return CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              value: value,
                              strokeAlign: 10,
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation((value >= 0.5
                                  ? const Color.fromARGB(255, 5, 148, 10)
                                  : const Color.fromARGB(255, 215, 21, 7))),
                            );
                          },
                        )
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                Text(
                  text,
                  textAlign: TextAlign.center,
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
            child: !isHome
                ? CardAndStatWidget(
                    red: _red, yellow: _yellow, pourcent: _valuePourcent)
                : null,
          )
        ],
      ),
    );
  }
}

class CardAndStatWidget extends StatelessWidget {
  final int red;
  final int yellow;
  final int? pourcent;
  const CardAndStatWidget(
      {super.key, this.red = 0, this.yellow = 0, this.pourcent});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      constraints: BoxConstraints(minWidth: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (yellow > 0)
                CardWidget(
                  nombre: yellow,
                  yellow: true,
                ),
              SizedBox(
                width: 2,
              ),
              if (red > 0)
                CardWidget(
                  nombre: red,
                  yellow: false,
                ),
            ],
          ),
          Text(
            pourcent != null ? '$pourcent%' : '',
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final int nombre;
  final bool yellow;
  const CardWidget({super.key, this.nombre = 0, this.yellow = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      width: 13,
      color: yellow
          ? const Color.fromARGB(255, 255, 230, 6)
          : const Color.fromARGB(255, 213, 20, 6),
      child: nombre >= 1
          ? Text(
              nombre.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            )
          : null,
    );
  }
}
