// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:app/collection/composition_collection.dart';
import 'package:app/core/enums/enums.dart';
import 'package:app/models/composition.dart';
import 'package:app/models/game.dart';
import 'package:app/pages/game/widget_details/composition_setter.dart';
import 'package:app/pages/joueur/joueur_details.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/coach/coach_and_team_widget.dart';
import 'package:app/widget/composition/composition_element_widget.dart';
import 'package:app/widget_pages/arbitre_list_widget.dart';
import 'package:app/widget_pages/substitut_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CompositionWidget extends StatelessWidget {
  final Game game;
  final bool checkUser;
  CompositionWidget({super.key, required this.game, required this.checkUser});

  late CompositionSousCollection compositionSousCollection;

  void _setCompositionSouscollection(
      CompositionCollection compositionCollection) {
    compositionSousCollection = CompositionSousCollection(
      game: game,
      homeInside: compositionCollection.getTitulaire(
          idGame: game.idGame, idParticipant: game.idHome),
      awayInside: compositionCollection.getTitulaire(
          idGame: game.idGame, idParticipant: game.idAway),
      homeOutside: compositionCollection.getRempl(
          create: false, idGame: game.idGame, idParticipant: game.idHome),
      awayOutside: compositionCollection.getRempl(
          create: false, idGame: game.idGame, idParticipant: game.idAway),
      arbitres: compositionCollection.getArbitresBygame(
          idGame: game.idGame, create: false),
      homeCoatch: compositionCollection.getCoach(
          idGame: game.idGame, idParticipant: game.idHome),
      awayCoatch: compositionCollection.getCoach(
          idGame: game.idGame, idParticipant: game.idAway),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<CompositionProvider>().getCompositions(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final CompositionCollection compositionCollection = snapshot.data!;
          _setCompositionSouscollection(compositionCollection);

          return Consumer<CompositionProvider>(
              builder: (context, compositionProvider, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (compositionSousCollection.homeInside.isNotEmpty &&
                          compositionSousCollection.awayInside.isNotEmpty ||
                      checkUser) ...[
                    Card(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 900,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                RotatedBox(
                                  quarterTurns: 1,
                                  child: Container(
                                    height: MediaQuery.of(context).size.width,
                                    width: 800,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                                AssetImage('images/stade.jpg'),
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                                PlayerListWidget(
                                  compositionSousCollection:
                                      compositionSousCollection,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: CoachAndTeamWidget(
                                equipe: game.home.nomEquipe,
                                composition:
                                    compositionSousCollection.homeCoatch),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CoachAndTeamWidget(
                                equipe: game.away.nomEquipe,
                                composition:
                                    compositionSousCollection.awayCoatch),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SubstitutListWidget(
                      compostitionWidgetType: CompostitionWidgetType.home,
                      compositionSousCollection: compositionSousCollection,
                    )
                  ],
                  ArbitreListWidget(
                    compostitionWidgetType: CompostitionWidgetType.home,
                    compositionSousCollection: compositionSousCollection,
                  ),
                  if (checkUser)
                    Card(
                      child: Center(
                        child: TextButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.blue),
                            ),
                            onPressed: () async {
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => CompositionSetter(
                                            compositionSousCollection:
                                                compositionSousCollection,
                                          )));
                            },
                            child: Text('Paramettre de Composition')),
                      ),
                    ),
                ],
              ),
            );
          });
        });
  }
}

// ignore: must_be_immutable
class PlayerListWidget extends StatelessWidget {
  final double height = 370;
  CompositionSousCollection compositionSousCollection;
  PlayerListWidget({super.key, required this.compositionSousCollection});

  @override
  Widget build(BuildContext context) {
    List<JoueurComposition> homepls = compositionSousCollection.homeInside;
    List<JoueurComposition> awaypls = compositionSousCollection.awayInside;

    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 800,
        child: Stack(
          fit: StackFit.expand,
          children: [
            for (JoueurComposition p in awaypls)
              Positioned(
                  left: p.left * constraint.maxWidth / height,
                  top: p.top,
                  child: PlayerWidget(
                    isHome: true,
                    composition: p,
                  )),
            for (JoueurComposition p in homepls)
              Positioned(
                  right: p.left * constraint.maxWidth / height,
                  bottom: p.top,
                  child: PlayerWidget(
                    isHome: false,
                    composition: p,
                  )),
          ],
        ),
      );
    });
  }
}

class PlayerWidget extends StatelessWidget {
  final JoueurComposition composition;
  final bool isHome;
  const PlayerWidget({
    super.key,
    required this.composition,
    required this.isHome,
  });
  void _onTap(BuildContext context, String id) async {
    final bool check = await context.read<JoueurProvider>().checkId(id);
    if (check) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => JoueurDetails(idJoueur: id)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          _onTap(context, composition.idJoueur);
        },
        child: CompositionElementWidget(
          composition: composition,
          isHome: isHome,
        ));
  }
}
