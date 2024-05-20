// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:app/collection/composition_collection.dart';
import 'package:app/models/composition.dart';
import 'package:app/models/game.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/widget/composition_bottom_sheet_widget.dart';
import 'package:app/widget/composition_element_widget.dart';
import 'package:app/widget_pages/substitut_list_widget.dart';
import 'package:app/widget_pages/composition_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CompositionSetter extends StatelessWidget {
  final Game game;
  late CompositionSousCollection compositionSousCollection;
  CompositionSetter({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    compositionSousCollection = CompositionSousCollection(
        awayInside: [], homeInside: [], homeOutside: [], awayOutside: []);
    return Scaffold(
      appBar: AppBar(
        title: Text('Composition'),
        actions: [],
      ),
      body: CompositionSetterWidget(
        compositionSousCollection: compositionSousCollection,
        game: game,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CompositionProvider>().setCompositions(game.idGame!, [
            ...compositionSousCollection.homeInside,
            ...compositionSousCollection.awayInside,
            ...compositionSousCollection.homeOutside,
            ...compositionSousCollection.awayOutside
          ]);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

// ignore: must_be_immutable
class CompositionSetterWidget extends StatefulWidget {
  final Game game;
  final CompositionSousCollection compositionSousCollection;

  CompositionSetterWidget({
    super.key,
    required this.game,
    required this.compositionSousCollection,
  });

  @override
  State<CompositionSetterWidget> createState() =>
      _CompositionSetterWidgetState();
}

class _CompositionSetterWidgetState extends State<CompositionSetterWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<CompositionProvider>().getCompositions(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('erreur!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }

          final CompositionCollection compositionCollection = snapshot.data!;
          widget.compositionSousCollection.homeInside =
              compositionCollection.getTitulaire(
                  idGame: widget.game.idGame!,
                  idParticipant: widget.game.idHome!);
          widget.compositionSousCollection.awayInside =
              compositionCollection.getTitulaire(
                  idGame: widget.game.idGame!,
                  idParticipant: widget.game.idAway!);
          widget.compositionSousCollection.homeOutside =
              compositionCollection.getRempl(
                  idGame: widget.game.idGame!,
                  idParticipant: widget.game.idHome!);
          widget.compositionSousCollection.awayOutside =
              compositionCollection.getRempl(
                  idGame: widget.game.idGame!,
                  idParticipant: widget.game.idAway!);

          return Consumer<CompositionProvider>(builder: (context, val, child) {
            return ListView(
              children: [
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
                                        image: AssetImage('images/stade.jpg'),
                                        fit: BoxFit.fill)),
                              ),
                            ),
                            PlayerListWidget2(
                              onUpdate: () {
                                setState(() {});
                              },
                              game: widget.game,
                              compositionSousCollection:
                                  widget.compositionSousCollection,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            widget.game.home ?? '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            widget.game.away ?? '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SubstitutListWidget(
                  onLongPress: (p0) {},
                  onDoubleTap: (p0) {},
                  game: widget.game,
                  compositionSousCollection: widget.compositionSousCollection,
                ),
              ],
            );
          });
        });
  }
}

class ToggleButtonsWidget extends StatelessWidget {
  final Function(int) onPressed;
  final int selected;
  const ToggleButtonsWidget(
      {super.key, required this.onPressed, required this.selected});

  @override
  Widget build(BuildContext context) {
    List<bool> isSelected = [false, false, false];
    isSelected[selected] = true;
    return Container(
      child: Column(
        children: [
          ToggleButtons(
              borderWidth: 5,
              textStyle: TextStyle(fontWeight: FontWeight.bold),
              fillColor: Colors.white,
              selectedColor: Colors.green,
              color: Colors.white,
              constraints: BoxConstraints(minHeight: 35),
              onPressed: onPressed,
              children: [
                Text('4-3-3'),
                Text('4-4-2'),
                Text('Pers.'),
              ],
              isSelected: isSelected),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class PlayerListWidget2 extends StatefulWidget {
  final Game game;
  final Function() onUpdate;
  CompositionSousCollection compositionSousCollection;
  PlayerListWidget2(
      {super.key,
      required this.game,
      required this.compositionSousCollection,
      required this.onUpdate});

  @override
  State<PlayerListWidget2> createState() => _PlayerListWidgetState2();
}

class _PlayerListWidgetState2 extends State<PlayerListWidget2> {
  late List<JoueurComposition> homes;
  late List<JoueurComposition> aways;

  int selectedHome = 0;
  int selectedAway = 0;
  void _onDoubleTap(JoueurComposition composition) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CompositionForm(composition: composition)));
    setState(() {});
  }

  void _onLongPress(JoueurComposition composition, List<JoueurComposition> data,
      bool isHome) async {
    final JoueurComposition? compos = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return CompositionBottomSheetWidget(compositions: data);
      },
    );
    if (compos != null) {
      final bool? confirm = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confimation du changement"),
            content: Text('Voulez vous effectuer cet Changement?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Non')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Oui')),
            ],
          );
        },
      );
      if (!(confirm ?? false)) {
        return;
      }

      if (isHome)
        widget.compositionSousCollection.changeHome(composition, compos);
      else
        widget.compositionSousCollection.changeAway(composition, compos);
    }
    // ignore: invalid_use_of_protected_member
    context.read<CompositionProvider>().notifyListeners();
  }

  @override
  void initState() {
    homes = widget.compositionSousCollection.homeInside;
    aways = widget.compositionSousCollection.awayInside;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 800,
      child: Stack(
        children: [
          for (JoueurComposition p in aways)
            AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                left: p.left,
                top: p.top,
                child: PlayerWidget2(
                  isHome: false,
                  onLongPress: (JoueurComposition composition) => _onLongPress(
                      p, widget.compositionSousCollection.awayOutside, false),
                  composition: p,
                  onDoubleTap: () {
                    _onDoubleTap(p);
                  },
                  onPanUpdate: (detail) {
                    setState(() {
                      selectedAway = 2;
                      p.left = p.left + detail.delta.dx;
                      p.top = p.top + detail.delta.dy;
                    });
                  },
                )),
          for (JoueurComposition p in homes)
            AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                right: p.left,
                bottom: p.top,
                child: PlayerWidget2(
                  isHome: true,
                  onLongPress: (JoueurComposition composition) => _onLongPress(
                      p, widget.compositionSousCollection.homeOutside, true),
                  composition: p,
                  onDoubleTap: () {
                    _onDoubleTap(p);
                  },
                  onPanUpdate: (detail) {
                    setState(() {
                      selectedHome = 2;
                      p.left = (p.left - detail.delta.dx);
                      p.top = (p.top - detail.delta.dy);
                    });
                  },
                )),
          Positioned(
              top: 0,
              right: 0,
              child: ToggleButtonsWidget(
                onPressed: (val) {
                  setState(() {
                    selectedHome = val;
                  });
                  if (val == 0) {
                    widget.compositionSousCollection.homeTo433();
                  }
                  if (val == 1) {
                    widget.compositionSousCollection.homeTo442();
                  }
                },
                selected: selectedHome,
              )),
          Positioned(
              bottom: 0,
              left: 0,
              child: ToggleButtonsWidget(
                onPressed: (val) {
                  if (val == 0) {
                    widget.compositionSousCollection.awayTo433();
                  }
                  if (val == 1) {
                    widget.compositionSousCollection.awayTo442();
                  }
                  setState(() {
                    selectedAway = val;
                  });
                },
                selected: selectedAway,
              )),
        ],
      ),
    );
  }
}

class PlayerWidget2 extends StatelessWidget {
  final JoueurComposition composition;
  final Function(JoueurComposition) onLongPress;
  final Function(DragUpdateDetails details) onPanUpdate;
  final Function() onDoubleTap;
  final bool isHome;
  const PlayerWidget2(
      {super.key,
      required this.composition,
      required this.onPanUpdate,
      required this.onDoubleTap,
      required this.onLongPress,
      required this.isHome});

  @override
  Widget build(BuildContext context) {
    return Draggable(
      onDragUpdate: onPanUpdate,
      feedback: Container(
        color: Colors.white,
        child: Icon(Icons.person),
      ),
      child: GestureDetector(
          onLongPress: () {
            onLongPress(composition);
          },
          onDoubleTap: onDoubleTap,
          child: CompositionElementWidget(
              composition: composition, isHome: isHome)),
    );
  }
}
