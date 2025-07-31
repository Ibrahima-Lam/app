import 'package:fscore/core/class/abbreviable.dart';
import 'package:fscore/models/api/fixture.dart';
import 'package:fscore/providers/paramettre_provider.dart';

import 'package:fscore/providers/game_provider.dart';
import 'package:fscore/widget/game/fixture_details_column_widget.dart';
import 'package:fscore/widget/game/fixture_details_score_column_widget.dart';
import 'package:fscore/widget/modals/custom_delegate_search.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:fscore/widget/skelton/tab_bar_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fscore/core/extension/string_extension.dart';

class FixtureDetails extends StatefulWidget {
  final Fixture fixture;
  const FixtureDetails({super.key, required this.fixture});
  @override
  State<FixtureDetails> createState() => _FixtureDetailsState();
}

class _FixtureDetailsState extends State<FixtureDetails> with Abbreviable {
  late final ScrollController _scrollController;
  final ValueNotifier<bool> _isExpended = ValueNotifier(true);
  bool checkUser = false;

  int tabBarIndex(List<String> tabs) {
    if (tabs.contains('statistique'))
      return tabs.indexWhere((element) => element == 'statistique');
    if (tabs.contains('evenement'))
      return tabs.indexWhere((element) => element == 'evenement');
    return 0;
  }

  Set<String> tabBarString(
      {bool composition = false,
      bool classement = false,
      bool statistique = false,
      bool evenement = false}) {
    return {
      'journee',
      'infos',
      if (classement) 'classement',
      if (composition) 'composition',
      if (evenement) 'evenement',
      if (statistique) 'statistique',
    };
  }

  Map<String, String> get tabBarLabel => {
        'journee': 'Journée',
        'infos': 'Infos',
        'classement': 'Classement',
        'composition': 'Composition',
        'evenement': 'Evènement',
        'statistique': 'Statistique',
      };

  Map<String, Widget> get tabBarViewChildren => {
        'journee': Center(child: Text('Journee')),
        'infos': Center(child: Text('Infos')),
        'classement': Center(child: Text('Classement')),
        'composition': Center(child: Text('Composition')),
        'evenement': Center(child: Text('Evenement')),
        'statistique': Center(child: Text('Statistique')),
      };
  List<String> tabs = [
    'journee',
    'infos',
    'classement',
    'composition',
    'evenement',
    'statistique'
  ];

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
    return LayoutBuilderWidget(
      child: FutureBuilder(
          future: null,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: const Center(
                  child: Text('erreur!'),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Consumer<ParamettreProvider>(
                builder: (context, paramettreProvider, _) {
              return DefaultTabController(
                initialIndex: 0,
                length: tabs.length,
                child: Scaffold(
                  body: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverAppBar(
                        pinned: true,
                        expandedHeight: 250,
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
                              icon: Icon(Icons.search)),
                        ],
                        centerTitle: true,
                        title: ValueListenableBuilder(
                            valueListenable: _isExpended,
                            builder: (context, val, child) {
                              return AnimatedOpacity(
                                opacity: _isExpended.value ? 0.0 : 1.0,
                                duration: Duration(milliseconds: 300),
                                child: Text(
                                  '${abbr(widget.fixture.teams.home.name)} ${widget.fixture.score?.score ?? ''} ${abbr(widget.fixture.teams.away.name)}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              );
                            }),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                Center(
                                  child: TextButton(
                                    onPressed: widget.fixture.league != null
                                        ? () {
                                            /* Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CompetitionDetails(
                                                        id: competition!
                                                            .codeEdition),
                                              ),
                                            ); */
                                          }
                                        : null,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${widget.fixture.league?.name ?? ''}. ',
                                          style: const TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          '${widget.fixture.league?.round?.capitalize() ?? ''}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(),
                                Consumer<GameProvider>(
                                  builder: (context, value, child) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: FixtureDetailsColumnWidget(
                                            isHome: true,
                                            team: widget.fixture.teams.home,
                                            league: widget.fixture.league,
                                          ),
                                        ),
                                        FixtureDetailsScoreColumnWidget(
                                            fixture: widget.fixture),
                                        Expanded(
                                          child: FixtureDetailsColumnWidget(
                                            isHome: false,
                                            team: widget.fixture.teams.away,
                                            league: widget.fixture.league,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        bottom: TabBarWidget.of(context).build(
                          tabs: [
                            for (final tab in tabs)
                              Tab(
                                text: tabBarLabel[tab] ?? '',
                              )
                          ],
                        ),
                      ),
                    ],
                    body: TabBarView(
                      children: [
                        for (final tab in tabs)
                          tabBarViewChildren[tab] ??
                              const Center(
                                child: Text('Page vide'),
                              )
                      ],
                    ),
                  ),
                ),
              );
            });
          }),
    );
  }
}
