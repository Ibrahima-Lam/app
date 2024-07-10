// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:app/collection/composition_collection.dart';
import 'package:app/models/composition.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/widget/coach_and_team_widget.dart';
import 'package:app/widget/modals/composition_bottom_sheet_widget.dart';
import 'package:app/widget/composition/composition_element_widget.dart';
import 'package:app/widget_pages/arbitre_form.dart';
import 'package:app/widget_pages/arbitre_widget.dart';
import 'package:app/widget_pages/coach_form.dart';
import 'package:app/widget_pages/event_form.dart';
import 'package:app/widget_pages/substitut_list_widget.dart';
import 'package:app/widget_pages/composition_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CompositionSetter extends StatelessWidget {
  final CompositionSousCollection compositionSousCollection;
  CompositionSetter({super.key, required this.compositionSousCollection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Composition'),
        actions: [],
      ),
      body: CompositionSetterWidget(
        compositionSousCollection: compositionSousCollection,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Todo enregistrer le formulaire des arbitres
          context
              .read<CompositionProvider>()
              .setCompositions(compositionSousCollection.game.idGame, [
            ...compositionSousCollection.homeInside,
            ...compositionSousCollection.awayInside,
            ...compositionSousCollection.homeOutside,
            ...compositionSousCollection.awayOutside,
            ...compositionSousCollection.arbitres,
            ...[
              compositionSousCollection.homeCoatch,
              compositionSousCollection.awayCoatch
            ]
          ]);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

// ignore: must_be_immutable
class CompositionSetterWidget extends StatefulWidget {
  final CompositionSousCollection compositionSousCollection;

  CompositionSetterWidget({
    super.key,
    required this.compositionSousCollection,
  });

  @override
  State<CompositionSetterWidget> createState() =>
      _CompositionSetterWidgetState();
}

class _CompositionSetterWidgetState extends State<CompositionSetterWidget> {
  void _onDoubleTapCoach(CoachComposition compostition) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CoachFormWidget(
              composition: compostition,
            )));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                        compositionSousCollection:
                            widget.compositionSousCollection,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: CoachAndTeamWidget(
                      onDoubleTap: () => _onDoubleTapCoach(
                          widget.compositionSousCollection.homeCoatch),
                      equipe: widget.compositionSousCollection.game.home ?? '',
                      composition: widget.compositionSousCollection.homeCoatch),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CoachAndTeamWidget(
                      onDoubleTap: () => _onDoubleTapCoach(
                          widget.compositionSousCollection.awayCoatch),
                      equipe: widget.compositionSousCollection.game.away ?? '',
                      composition: widget.compositionSousCollection.awayCoatch),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SubstitutListWidget(
            onTap: (p0) async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EventFormWidget(
                        composition: p0,
                      )));
            },
            onLongPress: (p0) {},
            onDoubleTap: (p0) {},
            compositionSousCollection: widget.compositionSousCollection,
          ),
          ArbitreWidget(
              onDoubleTap: (p0) async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ArbitreFormWidget(
                          composition: p0,
                        )));
              },
              compositionSousCollection: widget.compositionSousCollection),
        ],
      );
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
  final Function() onUpdate;
  CompositionSousCollection compositionSousCollection;
  PlayerListWidget2(
      {super.key,
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

  void _onTap(JoueurComposition composition) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EventFormWidget(composition: composition)));
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
                  onTap: () => _onTap(p),
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
                  onTap: () => _onTap(p),
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
  final Function() onTap;
  final bool isHome;
  const PlayerWidget2(
      {super.key,
      required this.composition,
      required this.onPanUpdate,
      required this.onDoubleTap,
      required this.onTap,
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
          onTap: onTap,
          onLongPress: () {
            onLongPress(composition);
          },
          onDoubleTap: onDoubleTap,
          child: CompositionElementWidget(
              composition: composition, isHome: isHome)),
    );
  }
}
