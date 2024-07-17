import 'dart:async';

import 'package:app/collection/competition_collection.dart';
import 'package:app/core/class/abbreviable.dart';
import 'package:app/core/enums/enums.dart';
import 'package:app/core/enums/game_etat_enum.dart';
import 'package:app/core/params/categorie/categorie_params.dart';
import 'package:app/models/competition.dart';
import 'package:app/models/game.dart';
import 'package:app/models/niveau.dart';
import 'package:app/pages/competition/competition_details.dart';
import 'package:app/pages/game/widget_details/composition_widget.dart';
import 'package:app/pages/game/widget_details/evenement_widget.dart';
import 'package:app/pages/game/widget_details/statistique_widget.dart';
import 'package:app/providers/paramettre_provider.dart';
import 'package:app/widget/classement/classement_widget.dart';
import 'package:app/pages/game/widget_details/journee_list_widget.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/game/game_bottom_navbar_edit_widget.dart';
import 'package:app/widget/game/game_bottom_niveau_edit_widget.dart';
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

  (List<String>, int) tabBarString(GameEtat gameEtat,
      {bool composition = false, bool classement = false}) {
    int initial = 0;
    if (gameEtat case (GameEtat.pause || GameEtat.direct || GameEtat.termine)) {
      initial = composition && classement
          ? 3
          : composition
              ? 3
              : 2;
      return (
        [
          'Journée',
          'Infos',
          if (classement) 'Classement',
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
        'Infos',
        if (classement) 'Classement',
        if (composition) 'Composition'
      ],
      initial
    );
  }

  List<Widget> tabBarViewChildren(List<String> tabs, bool checkUser) {
    List<Widget> widgets = [];
    for (String tab in tabs) {
      switch (tab.toUpperCase().substring(0, 3)) {
        case 'JOU':
          widgets.add(JourneeWidget(game: game));
          break;
        case 'CLA':
          widgets.add(ClassementWiget(
            codeEdition: game.groupe.codeEdition,
            title: 'Groupe ${game.groupe.nomGroupe}',
            idGroupe: game.idGroupe,
            targets: [game.idHome, game.idAway],
          ));
          break;
        case 'COM':
          widgets.add(CompositionWidget(
            checkUser: checkUser,
            game: game,
          ));
          break;
        case 'EVE':
          widgets.add(EvenementWidget(
            checkUser: checkUser,
            game: game,
          ));
        case 'STA':
          widgets.add(StatistiqueWidget(
            checkUser: checkUser,
            game: game,
          ));
          break;
        case 'INF':
          widgets.add(InfosListWiget(
            categorieParams: CategorieParams(
              idGame: game.idGame,
              idParticipant: game.idHome,
              idParticipant2: game.idAway,
            ),
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
                child: CircularProgressIndicator(),
              ),
            );
          }
          var (tabs, initial) = tabBarString(game.etat.etat,
              composition: true,
              classement: game.niveau.typeNiveau == 'groupe' ||
                  game.niveau.typeNiveau == 'championnat');
          return Consumer<ParamettreProvider>(builder: (context, val, _) {
            checkUser = val.checkUser(competition?.codeEdition ?? '');
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
                              text: tab,
                            )
                        ],
                      ),
                    ),
                  ],
                  body: TabBarView(
                    children: tabBarViewChildren(tabs, checkUser),
                  ),
                ),
                floatingActionButton: checkUser
                    ? FloatingActionButton(
                        onPressed: () async {
                          final res = await showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  GameBottomNiveauEditWidget());
                          if (res is Niveau) {
                            final bool? confirm = await showDialog(
                                context: context,
                                builder: (context) => ConfirmDialogWidget(
                                      defaut: ConfirmDialogDefault.non,
                                      title: 'Changer le Niveau',
                                      content:
                                          'Voulez vous changer le niveau ?',
                                    ));
                            if (confirm == true) {
                              context.read<GameProvider>().changeNiveau(
                                  idGame: game.idGame, niveau: res);
                            }
                          } else if (res == false) {
                            final bool? confirm = await showDialog(
                                context: context,
                                builder: (context) => ConfirmDialogWidget(
                                      defaut: ConfirmDialogDefault.non,
                                      title: 'Supprimer le niveau',
                                      content:
                                          'Voulez vous supprimer le niveau ?',
                                    ));
                            if (confirm == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('pas d\action!'),
                                  duration: const Duration(milliseconds: 200),
                                ),
                              );
                            }
                          }
                        },
                        child: Icon(Icons.label_important),
                      )
                    : null,
                bottomNavigationBar:
                    checkUser ? GameBottomNavbarEditWidget(game: game) : null,
              ),
            );
          });
        });
  }
}
