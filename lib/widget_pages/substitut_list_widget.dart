// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:app/collection/composition_collection.dart';
import 'package:app/controllers/competition/date.dart';
import 'package:app/core/constants/event/kEvent.dart';
import 'package:app/core/constants/strategie/rempl.dart';
import 'package:app/core/enums/enums.dart';
import 'package:app/models/composition.dart';
import 'package:app/models/event.dart';
import 'package:app/pages/joueur/joueur_details.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/modals/composition_bottom_sheet_widget.dart';
import 'package:app/widget/modals/confirm_dialog_widget.dart';
import 'package:app/widget/app/section_title_widget.dart';
import 'package:app/widget/logos/substitut_logo_widget.dart';
import 'package:app/widget_pages/composition_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SubstitutListTile extends StatelessWidget {
  final bool isHome;
  final JoueurComposition composition;
  final Function(JoueurComposition)? onDoubleTap;
  final Function(JoueurComposition) onDelete;
  final Function(JoueurComposition) onCancelChange;
  final CompostitionWidgetType compostitionWidgetType;
  final Function(JoueurComposition)? onTap;
  final Function(JoueurComposition)? onLongPress;
  const SubstitutListTile(
      {super.key,
      required this.isHome,
      required this.composition,
      this.onDoubleTap,
      this.onTap,
      required this.onDelete,
      required this.onCancelChange,
      required this.compostitionWidgetType,
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
      child: Slidable(
        key: ValueKey(composition.idComposition),
        enabled: compostitionWidgetType == CompostitionWidgetType.setting,
        startActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: 0.5,
          children: [
            SlidableAction(
              onPressed: (context) => onDelete(composition),
              icon: Icons.delete,
              foregroundColor: Colors.red,
            ),
          ],
        ),
        endActionPane: composition.sortant != null
            ? ActionPane(
                motion: DrawerMotion(),
                extentRatio: 0.5,
                children: [
                  SlidableAction(
                    onPressed: (context) => onCancelChange(composition),
                    icon: Icons.clear,
                    foregroundColor: Colors.orange,
                  ),
                ],
              )
            : null,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          horizontalTitleGap: 5.0,
          onTap: onTap == null
              ? null
              : () {
                  onTap!(composition);
                },
          onLongPress: onLongPress == null
              ? null
              : () {
                  onLongPress!(composition);
                },
          leading:
              isHome ? null : SubstitutLogoWidget(composition: composition),
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
          trailing:
              isHome ? SubstitutLogoWidget(composition: composition) : null,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SubstitutListWidget extends StatefulWidget {
  final CompositionSousCollection compositionSousCollection;
  final Function()? update;

  final CompostitionWidgetType compostitionWidgetType;

  SubstitutListWidget({
    super.key,
    required this.compositionSousCollection,
    required this.compostitionWidgetType,
    this.update,
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

  void _onTap(JoueurComposition composition) async {
    final bool check =
        await context.read<JoueurProvider>().checkId(composition.idJoueur);
    if (check) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => JoueurDetails(idJoueur: composition.idJoueur)));
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
            title: "Changement",
            content: 'Voulez vous effectuer ce Changement ?',
          );
        },
      );
      if (!(confirm ?? false)) {
        return;
      }
      RemplEvent event = kRemplEvent.copyWith(
        idEvent: 'R${DateController.dateCollapsed}',
        idGame: composition.idGame,
        idParticipant: composition.idParticipant,
        idJoueur: compos.idJoueur,
        nom: compos.nom,
        idTarget: composition.idJoueur,
        nomTarget: composition.nom,
      );
      await context.read<GameEventListProvider>().addEvent(event);
      widget.update!();
    }
  }

  void _onDelete(
      BuildContext context, JoueurComposition composition, bool isHome) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => ConfirmDialogWidget(
        title: 'Suppression',
        content: 'Voulez vous supprimer cette élément ?',
      ),
    );
    if (confirm == true) {
      final bool res = await context
          .read<CompositionProvider>()
          .deleteComposition(composition.idComposition);
      if (res) {
        widget.compositionSousCollection.cancelChange(composition, isHome);
        widget.compositionSousCollection
            .removeRemplComposition(composition.idComposition, isHome);
        widget.update!();
      }
      String message = res ? 'Supprimé' : 'Echec de suppression!';
      await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(milliseconds: 200),
        ),
      );
    }
  }

  void _onCancelChange(
      BuildContext context, JoueurComposition composition, bool isHome) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => ConfirmDialogWidget(
        title: 'Annulation',
        content: 'Voulez vous annuler ce changement ?',
      ),
    );
    if (confirm == true)
      widget.compositionSousCollection.cancelChange(composition, isHome);
    widget.update!();
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
                          compostitionWidgetType: widget.compostitionWidgetType,
                          onDelete: (p0) => _onDelete(context, home, true),
                          onCancelChange: (h) =>
                              _onCancelChange(context, h, true),
                          isHome: true,
                          onTap: (e) => _onTap(home),
                          onDoubleTap: widget.compostitionWidgetType ==
                                  CompostitionWidgetType.home
                              ? null
                              : (JoueurComposition comp) {
                                  home = comp;
                                  setState(() {});
                                },
                          onLongPress: widget.compostitionWidgetType ==
                                  CompostitionWidgetType.home
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
                          compostitionWidgetType: widget.compostitionWidgetType,
                          onDelete: (p0) => _onDelete(context, away, false),
                          onCancelChange: (a) =>
                              _onCancelChange(context, a, false),
                          isHome: false,
                          onTap: (p) => _onTap(away),
                          onDoubleTap: widget.compostitionWidgetType ==
                                  CompostitionWidgetType.home
                              ? null
                              : (JoueurComposition comp) {
                                  away = comp;
                                  setState(() {});
                                },
                          onLongPress: widget.compostitionWidgetType ==
                                  CompostitionWidgetType.home
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
          if (widget.compostitionWidgetType == CompostitionWidgetType.setting)
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
