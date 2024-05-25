// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:app/collection/composition_collection.dart';
import 'package:app/models/composition.dart';
import 'package:app/models/game.dart';
import 'package:app/pages/joueur/joueur_details.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/composition_bottom_sheet_widget.dart';
import 'package:app/widget/composition_events_widget.dart';
import 'package:app/widget_pages/composition_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubstitutLogoWidget extends StatelessWidget {
  const SubstitutLogoWidget({super.key, required this.composition});
  final JoueurComposition composition;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
        ),
        Badge(
          backgroundColor: Colors.black,
          textColor: Colors.white,
          offset: Offset(0, 5),
          label: Text(composition.numero.toString()),
          alignment: Alignment.bottomCenter,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: const Color(0xFFDCDCDC),
            foregroundColor: Colors.white,
            child: Icon(Icons.person),
          ),
        ),
        if (composition.but > 0)
          Positioned(
              left: 0,
              top: 0,
              child: GoalWidget(
                but: composition.but,
              )),
        if (composition.entrant != null)
          Positioned(
              left: 0,
              top: 22,
              child: Icon(
                Icons.subdirectory_arrow_left,
                color: Colors.red,
                size: 20,
              )),
        if (composition.jaune > 0)
          Positioned(right: 0, top: 5, child: CardWidget()),
        if (composition.rouge > 0)
          Positioned(
              right: 3,
              top: 0,
              child: CardWidget(
                isRed: true,
              )),
        if (composition.isCapitaine)
          Positioned(right: 0, top: 25, child: CapitaineWidget()),
      ],
    );
  }
}

// ignore: must_be_immutable
class SubstitutListTile extends StatelessWidget {
  final bool isHome;
  final JoueurComposition composition;
  final Function(JoueurComposition)? onDoubleTap;
  final Function(String)? onTap;
  final Function(JoueurComposition)? onLongPress;
  SubstitutListTile(
      {super.key,
      required this.isHome,
      required this.composition,
      this.onDoubleTap,
      this.onTap,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap == null
          ? null
          : () async {
              final JoueurComposition? comp = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          CompositionForm(composition: composition)));
              if (comp != null) {
                onDoubleTap!(comp);
              }
            },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        horizontalTitleGap: 5.0,
        onTap: onTap == null
            ? null
            : () {
                onTap!(composition.idJoueur);
              },
        onLongPress: onLongPress == null
            ? null
            : () {
                onLongPress!(composition);
              },
        leading: isHome ? null : SubstitutLogoWidget(composition: composition),
        title: Text(
          composition.nom,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13),
        ),
        subtitle: composition.sortant == null
            ? const Text('')
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.subdirectory_arrow_left,
                      color: Colors.red, size: 15),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    composition.sortant!.nom,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
        trailing: isHome ? SubstitutLogoWidget(composition: composition) : null,
      ),
    );
  }
}

// ignore: must_be_immutable
class SubstitutListWidget extends StatefulWidget {
  final Game game;
  final CompositionSousCollection compositionSousCollection;
  final Function(JoueurComposition)? onTap;
  final Function(JoueurComposition)? onDoubleTap;
  final Function(JoueurComposition)? onLongPress;

  SubstitutListWidget({
    super.key,
    required this.game,
    required this.compositionSousCollection,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  });

  @override
  State<SubstitutListWidget> createState() => _SubstitutListWidgetState();
}

class _SubstitutListWidgetState extends State<SubstitutListWidget> {
  late List<JoueurComposition> homes;
  late List<JoueurComposition> aways;

  @override
  void initState() {
    homes = widget.compositionSousCollection.homeOutside;
    aways = widget.compositionSousCollection.awayOutside;

    super.initState();
  }

  void _onTap(String id) async {
    final bool check = await context.read<JoueurProvider>().checkId(id);
    if (check) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => JoueurDetails(idJoueur: id)));
    }
  }

  void _onLongPress(JoueurComposition composition, List<JoueurComposition> data,
      bool isHome) async {
    JoueurComposition? compos = await showModalBottomSheet(
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
            content: Text('Voulez vous effectuer cet Changement ?'),
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
        widget.compositionSousCollection.changeHome(compos, composition);
      else
        widget.compositionSousCollection.changeAway(compos, composition);

      // ignore: invalid_use_of_protected_member
      context.read<CompositionProvider>().notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            color: const Color(0xFFDCDCDC),
            child: const Text(
              'Remplaçants',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.game.home ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.game.away ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
          Row(children: [
            Expanded(
              child: Column(children: [
                for (JoueurComposition home in homes)
                  SubstitutListTile(
                    isHome: true,
                    onTap: widget.onTap == null
                        ? _onTap
                        : (p0) async {
                            await widget.onTap!(home);
                            setState(() {});
                          },
                    onDoubleTap: widget.onDoubleTap == null
                        ? null
                        : (JoueurComposition comp) {
                            home = comp;
                            setState(() {});
                          },
                    onLongPress: widget.onLongPress == null
                        ? null
                        : (composition) {
                            _onLongPress(
                                composition,
                                widget.compositionSousCollection.homeInside,
                                true);
                          },
                    composition: home,
                  )
              ]),
            ),
            Expanded(
              child: Column(children: [
                for (JoueurComposition away in aways)
                  SubstitutListTile(
                    isHome: false,
                    onTap: widget.onTap == null
                        ? _onTap
                        : (p0) async {
                            await widget.onTap!(away);
                            setState(() {});
                          },
                    onDoubleTap: widget.onDoubleTap == null
                        ? null
                        : (JoueurComposition comp) {
                            away = comp;
                            setState(() {});
                          },
                    onLongPress: widget.onLongPress == null
                        ? null
                        : (composition) {
                            _onLongPress(
                                composition,
                                widget.compositionSousCollection.awayInside,
                                false);
                          },
                    composition: away,
                  )
              ]),
            ),
          ]),
        ],
      ),
    );
  }
}
