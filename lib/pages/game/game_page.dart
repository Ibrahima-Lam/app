import 'package:app/collection/competition_collection.dart';
import 'package:app/collection/game_collection.dart';
import 'package:app/controllers/competition/date.dart';
import 'package:app/models/competition.dart';
import 'package:app/models/game.dart';
import 'package:app/pages/competition/competition_details.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/custom_delegate_search.dart';
import 'package:app/widget/game_widget.dart';
import 'package:app/widget/scaffold_widget.dart';
import 'package:app/widget/tab_bar_widget.dart';
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

  TabController? _tabController;
  DateTime initialDate = DateTime.now();

  Future _showCalendar([data]) async {
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
        fieldLabelText: 'Entrer un date',
      ),
    );
    initialDate = date ?? DateTime.now();
    _setTabs(date);
    _tabController!.index = 7;
  }

  Future _showSearch() async {
    await showSearch(context: context, delegate: CustomDelegateSearch());
  }

  void _setTabs(DateTime? date) {
    List<String> newdates = [];
    for (var i = -7; i <= 7; i++) {
      String dt = date!.add(Duration(days: i)).toString().substring(0, 10);
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

    _tabController!.addListener(() {
      if ((_tabController!.index == 0 ||
              _tabController!.index == tabs.length - 1) &&
          !_tabController!.indexIsChanging) {
        initialDate = _tabController!.index == 0
            ? DateTime.parse(tabs[0])
            : DateTime.parse(tabs[tabs.length - 1]);
        _showCalendar();
      }
    });
  }

  bool _setPlaying() {
    setState(() {
      playing = !playing;
    });
    return playing;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 2,
      length: tabs.length,
      child: ScaffoldWidget(
        playing: playing,
        openDrawer: widget.openDrawer,
        onPressedSearch: _showSearch,
        onPressedCalendar: _showCalendar,
        onPressedStream: _setPlaying,
        bottom: TabBarWidget.build(controller: _tabController, tabs: [
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
                  child: Text('Erreur!'),
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
        floatButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }
}

// -----------------------------------WIDGET----------------------------------------------

class CompetitionGamesWidget extends StatefulWidget {
  final String date;
  final bool playing;
  final List<Competition> competitions;
  const CompetitionGamesWidget(
      {super.key,
      required this.date,
      required this.competitions,
      required this.playing});

  @override
  State<CompetitionGamesWidget> createState() => _CompetitionGamesWidgetState();
}

class _CompetitionGamesWidgetState extends State<CompetitionGamesWidget> {
  final String _message = 'Pas de Match Pour cette date!';

  @override
  void initState() {
    super.initState();
  }

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
            return const Center(
              child: Text('Erreur'),
            );
          }
          return Consumer<GameProvider>(builder: (context, value, child) {
            GameCollection gameCollection = value.gameCollection;
            return gameCollection
                    .getGamesBy(dateGame: widget.date, playing: widget.playing)
                    .isEmpty
                ? Center(
                    child: Text(_message),
                  )
                : ListView.separated(
                    itemCount: widget.competitions.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 5,
                    ),
                    itemBuilder: (context, index) {
                      Competition competition = widget.competitions[index];
                      final List<Game> gamelist = gameCollection.getGamesBy(
                        dateGame: widget.date,
                        codeEdition: competition.codeEdition,
                      );
                      if (gamelist.isEmpty) {
                        return SizedBox();
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Card(
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          elevation: 1,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          shadowColor: Colors.grey,
                          child: Column(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CompetitionDetails(
                                              id: competition.codeEdition!,
                                            ))),
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.cabin),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            competition.nomCompetition!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                      PopupMenuButton(
                                        color: Colors.white,
                                        surfaceTintColor: Colors.white,
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                              child: Icon(Icons.star)),
                                          PopupMenuItem(
                                              child: Icon(Icons.notifications)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.grey,
                              ),
                              for (final g in gamelist)
                                GameWidget(
                                  game: g,
                                  showDate: false,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          });
        });
  }
}
