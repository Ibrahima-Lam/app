import 'package:app/collection/competition_collection.dart';
import 'package:app/controllers/competition/date.dart';
import 'package:app/models/competition.dart';
import 'package:app/models/game.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/providers/favori_provider.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/app/favori_title_widget.dart';
import 'package:app/widget/app/top_icons_widget.dart';
import 'package:app/widget/competition/competition_title_widget.dart';
import 'package:app/widget/modals/custom_delegate_search.dart';
import 'package:app/widget/game/game_widget.dart';
import 'package:app/widget/skelton/scaffold_widget.dart';
import 'package:app/widget/sponsor/sponsor_list_widget.dart';
import 'package:app/widget/skelton/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  final Function()? openDrawer;
  const GamePage({super.key, this.openDrawer});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  late List<String> tabs;
  bool playing = false;

  late TabController _tabController;
  DateTime initialDate = DateTime.now();

  Future _showCalendar() async {
    final int year = DateTime.now().year;
    final DateTime? date = await showDialog(
      context: context,
      builder: (context) => DatePickerDialog(
        firstDate: DateTime(year - 5),
        lastDate: DateTime(year + 5),
        initialDate: initialDate,
        cancelText: 'Annuler',
        confirmText: 'Séléctionner',
        helpText: "Séléctionner une date",
        fieldLabelText: 'Entrer une date',
      ),
    );
    playing = false;
    initialDate = date ?? DateTime.now();
    _setTabs(initialDate);
    _tabController.animateTo(7);
  }

  Future _showSearch() async {
    await showSearch(
      context: context,
      delegate: CustomDelegateSearch(),
    );
  }

  void _setTabs(DateTime date, [bool one = false]) {
    if (one) {
      setState(() {
        tabs = [date.toString().substring(0, 10)];
      });
      return;
    }
    List<String> newdates = [];
    for (var i = -7; i <= 7; i++) {
      String dt = date.add(Duration(days: i)).toString().substring(0, 10);
      newdates.add(dt);
    }
    setState(() {
      tabs = newdates;
    });
  }

  @override
  void initState() {
    super.initState();

    _setTabs(DateTime.now());
    _tabController = TabController(
      initialIndex: tabs.length ~/ 2,
      length: tabs.length,
      vsync: this,
      animationDuration: const Duration(milliseconds: 200),
    );

    _tabController.addListener(() {
      if ((_tabController.index == 0 ||
              _tabController.index == tabs.length - 1) &&
          !_tabController.indexIsChanging &&
          !playing) {
        initialDate = _tabController.index == 0
            ? DateTime.parse(tabs[0])
            : DateTime.parse(tabs[tabs.length - 1]);
        _showCalendar();
      }
    });
  }

  bool _setPlaying() {
    playing = !playing;

    if (!playing) {
      _setTabs(DateTime.now());
      _tabController.animateTo(tabs.length ~/ 2);
    } else {
      _tabController.index = 0;
      _setTabs(DateTime.now(), true);
    }
    return playing;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: playing ? 0 : 7,
      length: tabs.length,
      child: ScaffoldWidget(
        playing: playing,
        openDrawer: widget.openDrawer,
        onPressedSearch: _showSearch,
        onPressedCalendar: _showCalendar,
        onPressedStream: _setPlaying,
        bottom: TabBarWidget.build(
            tabAlignment: playing ? TabAlignment.center : null,
            controller: _tabController,
            tabs: playing
                ? [
                    Tab(
                      text: 'En Direct',
                    )
                  ]
                : [
                    for (final tab in DateController.frDates(tabs))
                      Tab(
                        text: tab,
                      )
                  ]),
        body: FutureBuilder<CompetitionCollection>(
            future: context.read<CompetitionProvider>().getCompetitions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('erreur!'),
                );
              }

              return Consumer<CompetitionProvider>(
                  builder: (context, value, child) {
                List<Competition> competitions = value.collection.competitions;
                return TabBarView(
                  controller: _tabController,
                  children: [
                    for (final tab in tabs)
                      CompetitionGamesWidget(
                        date: tab,
                        competitions: competitions,
                        playing: playing,
                      )
                  ],
                );
              });
            }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}

// -----------------------------------WIDGET----------------------------------------------

class CompetitionGamesWidget extends StatelessWidget {
  final String date;
  final bool playing;
  final List<Competition> competitions;
  const CompetitionGamesWidget(
      {super.key,
      required this.date,
      required this.competitions,
      required this.playing});

  final String _message = 'Pas de Match Pour cette date!';
  List<Game> getTodayGames(GameProvider gameProvider) =>
      gameProvider.getGamesBy(dateGame: date, playing: playing);

  List<Game> getFavoriteGames(
      GameProvider gameProvider, FavoriProvider favoriProvider) {
    List<Game> games = getTodayGames(gameProvider);
    games = games
        .where((element) =>
            favoriProvider.competitions
                .any((elmt) => elmt == element.groupe.codeEdition) ||
            favoriProvider.equipes.any(
                (elmt) => elmt == element.idHome || elmt == element.idAway))
        .toList();
    return games;
  }

  List<Game> getCompetitionGames(
          Competition competition, List<Game> games) =>
      games
          .where((element) =>
              element.groupe.codeEdition == competition.codeEdition)
          .toList();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<GameProvider>().getGames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return Consumer2<GameProvider, FavoriProvider>(
              builder: (context, gameProvider, favoriProvider, child) {
            return gameProvider
                    .getGamesBy(dateGame: date, playing: playing)
                    .isEmpty
                ? Center(
                    child: Text(_message),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            TopIconsWidget(
                              playing: playing,
                              gameProvider: gameProvider,
                              dateGame: date,
                              competitions: competitions,
                            ),
                            FavorisSectionWidget(
                                gameProvider: gameProvider,
                                favoriProvider: favoriProvider,
                                date: date,
                                competitions: competitions,
                                playing: playing),
                            NonFavorisSectionWidget(
                                gameProvider: gameProvider,
                                favoriProvider: favoriProvider,
                                date: date,
                                competitions: competitions,
                                playing: playing),
                            SponsorListWidget(),
                          ],
                        ),
                      ],
                    ),
                  );
          });
        });
  }
}

class FavorisSectionWidget extends CompetitionGamesWidget {
  final GameProvider gameProvider;
  final FavoriProvider favoriProvider;

  const FavorisSectionWidget(
      {super.key,
      required this.gameProvider,
      required this.favoriProvider,
      required super.date,
      required super.competitions,
      required super.playing});

  @override
  Widget build(BuildContext context) {
    List<Game> games = getFavoriteGames(gameProvider, favoriProvider);
    if (games.isEmpty) return const SizedBox();
    List<Competition> comps = competitions
        .where((element) =>
            games.any((elmt) => elmt.groupe.codeEdition == element.codeEdition))
        .toList();
    return Column(
      children: [
        FavoriTitleWidget(),
        for (Competition competition in comps)
          CompetitionSectionWidget(
              competition: competition,
              games: getCompetitionGames(competition, games),
              gameEventListProvider: gameProvider.gameEventListProvider),
      ],
    );
  }
}

class NonFavorisSectionWidget extends CompetitionGamesWidget {
  final GameProvider gameProvider;
  final FavoriProvider favoriProvider;

  const NonFavorisSectionWidget(
      {super.key,
      required this.gameProvider,
      required this.favoriProvider,
      required super.date,
      required super.competitions,
      required super.playing});

  @override
  Widget build(BuildContext context) {
    List<Game> favoris = getFavoriteGames(gameProvider, favoriProvider);
    List<Game> games = getTodayGames(gameProvider)
        .where(
            (element) => favoris.every((elmt) => elmt.idGame != element.idGame))
        .toList();
    if (games.isEmpty) return const SizedBox();
    List<Competition> comps = competitions
        .where((element) =>
            games.any((elmt) => elmt.groupe.codeEdition == element.codeEdition))
        .toList();
    return Column(
      children: [
        if (favoris.isNotEmpty) const SizedBox(height: 10),
        if (favoris.isNotEmpty) FavoriTitleWidget(nonFavori: true),
        for (Competition competition in comps)
          CompetitionSectionWidget(
              competition: competition,
              games: getCompetitionGames(competition, games),
              gameEventListProvider: gameProvider.gameEventListProvider)
      ],
    );
  }
}

class CompetitionSectionWidget extends StatelessWidget {
  final Competition competition;
  final List<Game> games;
  final GameEventListProvider gameEventListProvider;
  const CompetitionSectionWidget(
      {super.key,
      required this.competition,
      required this.games,
      required this.gameEventListProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CompetitionTitleWidget(competition: competition),
        for (final g in games)
          GameLessWidget(
            gameEventListProvider: gameEventListProvider,
            game: g,
            showDate: false,
          ),
        const SizedBox(
          height: 5.0,
        )
      ],
    );
  }
}
