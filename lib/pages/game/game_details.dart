import 'dart:async';

import 'package:app/collection/competition_collection.dart';
import 'package:app/core/class/abbreviable.dart';
import 'package:app/core/enums/enums.dart';
import 'package:app/core/params/categorie/categorie_params.dart';
import 'package:app/models/competition.dart';
import 'package:app/models/game.dart';
import 'package:app/models/paramettre.dart';
import 'package:app/pages/competition/competition_details.dart';
import 'package:app/pages/game/widget_details/composition_widget.dart';
import 'package:app/pages/game/widget_details/evenement_widget.dart';
import 'package:app/pages/game/widget_details/statistique_list_widget.dart';
import 'package:app/providers/paramettre_provider.dart';
import 'package:app/providers/score_provider.dart';
import 'package:app/widget/classement/classement_widget.dart';
import 'package:app/pages/game/widget_details/journee_list_widget.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/game/game_bottom_navbar_edit_widget.dart';
import 'package:app/widget/game/game_details_column_widget.dart';
import 'package:app/widget/game/game_details_score_column_widget.dart';
import 'package:app/widget/modals/confirm_dialog_widget.dart';
import 'package:app/widget/modals/custom_delegate_search.dart';
import 'package:app/widget/skelton/tab_bar_widget.dart';
import 'package:app/widget_pages/infos_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/core/extension/string_extension.dart';

class GameDetails extends StatefulWidget {
  final String id;
  const GameDetails({super.key, required this.id});
  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> with Abbreviable {
  late Game game;
  late Competition? competition;
  late final ScrollController _scrollController;
  final ValueNotifier<bool> _isExpended = ValueNotifier(true);
  bool checkUser = false;

  Future<bool> _getData(BuildContext context) async {
    GameProvider gameProvider = await context.read<GameProvider>()
      ..getGames();
    game = gameProvider.getElementAt(widget.id);
    String codeEdition = game.groupe.codeEdition;
    CompetitionCollection _competitionColletion =
        await context.read<CompetitionProvider>().getCompetitions();
    competition = _competitionColletion.getElementAt(codeEdition);
    return true;
  }

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
        'journee': JourneeWidget(game: game),
        'infos': InfosListWiget(
          categorieParams: CategorieParams(
            idEdition: game.groupe.codeEdition,
            idGame: game.idGame,
            idParticipant: game.idHome,
            idParticipant2: game.idAway,
          ),
        ),
        'classement': ClassementWiget(
          key: ValueKey('comp'),
          codeEdition: game.groupe.codeEdition,
          title: 'Groupe ${game.groupe.nomGroupe}',
          idGroupe: game.idGroupe,
          targets: [game.idHome, game.idAway],
        ),
        'composition': CompositionWidget(
          key: ValueKey('class'),
          checkUser: checkUser,
          game: game,
        ),
        'evenement': EvenementWidget(
          key: ValueKey('eve'),
          checkUser: checkUser,
          game: game,
        ),
        'statistique': StatistiqueListWidget(
          key: ValueKey('stat'),
          checkUser: checkUser,
          game: game,
        ),
      };

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
            checkUser =
                paramettreProvider.checkUser(competition?.codeEdition ?? '');
            final Paramettre? paramettre = paramettreProvider
                .getCompetitionParamettre(game.groupe.codeEdition);
            Set<String> tabs = tabBarString(
              composition: (paramettre?.showComposition ?? false),
              classement: game.niveau.typeNiveau == 'groupe' ||
                  game.niveau.typeNiveau == 'championnat',
              evenement:
                  game.etat.started && (paramettre?.showEvenement ?? true),
              statistique:
                  game.etat.started && (paramettre?.showStatistique ?? true),
            );
            int initial = tabBarIndex(tabs.toList());

            return DefaultTabController(
              initialIndex: initial,
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
                                '${abbr(game.home.nomEquipe)} ${game.scoreText} ${abbr(game.away.nomEquipe.toString())}',
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
                                  onPressed: competition != null
                                      ? () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CompetitionDetails(
                                                      id: competition!
                                                          .codeEdition),
                                            ),
                                          );
                                        }
                                      : null,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${competition?.nomCompetition ?? ''}. ',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        '${game.niveau.nomNiveau.capitalize()}',
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
                                        child: GameDetailsColumnWidget(
                                          text: game.home.nomEquipe,
                                          id: game.idHome,
                                          isHome: true,
                                          game: game,
                                        ),
                                      ),
                                      GameDetailsScoreColumnWidget(
                                        game: game,
                                        timer: game.score?.timer,
                                      ),
                                      Expanded(
                                        child: GameDetailsColumnWidget(
                                          text: game.away.nomEquipe,
                                          id: game.idAway,
                                          isHome: false,
                                          game: game,
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
                      bottom: TabBarWidget.build(
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
                bottomNavigationBar:
                    checkUser ? GameBottomNavbarEditWidget(game: game) : null,
                floatingActionButton: checkUser && game.score != null
                    ? FloatingActionButton(
                        onPressed: () async {
                          final bool? confirm = await showDialog(
                              context: context,
                              builder: (context) => ConfirmDialogWidget(
                                  defaut: ConfirmDialogDefault.non,
                                  title: 'Confirmer la suppression',
                                  content: 'Voulez vous supprimer le score ?'));
                          if (confirm == true)
                            context
                                .read<ScoreProvider>()
                                .deleteScore(game.idGame);
                        },
                        child: const Icon(Icons.delete),
                      )
                    : null,
              ),
            );
          });
        });
  }
}
