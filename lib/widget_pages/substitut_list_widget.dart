// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:app/collection/composition_collection.dart';
import 'package:app/core/constants/strategie/rempl.dart';
import 'package:app/models/composition.dart';
import 'package:app/pages/joueur/joueur_details.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/modals/composition_bottom_sheet_widget.dart';
import 'package:app/widget/modals/confirm_dialog_widget.dart';
import 'package:app/widget/section_title_widget.dart';
import 'package:app/widget/logos/substitut_logo_widget.dart';
import 'package:app/widget_pages/composition_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final CompositionSousCollection compositionSousCollection;
  final Function(JoueurComposition)? onTap;
  final Function(JoueurComposition)? onDoubleTap;
  final Function(JoueurComposition)? onLongPress;

  SubstitutListWidget({
    super.key,
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
          return ConfirmDialogWidget(
            title: "Confimation du changement",
            content: 'Voulez vous effectuer cet Changement ?',
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
          SectionTitleWidget(title: 'Remplaçants'),
          Container(
              padding: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.compositionSousCollection.game.home.nomEquipe,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.compositionSousCollection.game.away.nomEquipe,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
          widget.compositionSousCollection.homeOutside.isEmpty &&
                  widget.compositionSousCollection.awayOutside.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Pas de remplaçant disponible !'),
                  ),
                )
              : Row(children: [
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
                                      widget
                                          .compositionSousCollection.homeInside,
                                      true);
                                },
                          composition: home,
                        ),
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
                                      widget
                                          .compositionSousCollection.awayInside,
                                      false);
                                },
                          composition: away,
                        ),
                    ]),
                  ),
                ]),
          if (widget.onDoubleTap != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        widget.compositionSousCollection.homeOutside
                            .add(kRemplComposition.copyWith(
                          idGame: widget.compositionSousCollection.game.idGame,
                          idParticipant:
                              widget.compositionSousCollection.game.idHome,
                        ));
                      });
                    },
                    child: Text('Ajouter')),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        widget.compositionSousCollection.awayOutside
                            .add(kRemplComposition.copyWith(
                          idGame: widget.compositionSousCollection.game.idGame,
                          idParticipant:
                              widget.compositionSousCollection.game.idAway,
                        ));
                      });
                    },
                    child: Text('Ajouter')),
              ],
            )
        ],
      ),
    );
  }
}
