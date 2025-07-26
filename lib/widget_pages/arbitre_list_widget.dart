import 'package:fscore/collection/composition_collection.dart';
import 'package:fscore/core/constants/arbitre/kArbitre.dart';
import 'package:fscore/core/enums/enums.dart';
import 'package:fscore/models/composition.dart';
import 'package:fscore/pages/arbitre/arbitre_details.dart';
import 'package:fscore/providers/arbitre_provider.dart';
import 'package:fscore/providers/composition_provider.dart';
import 'package:fscore/widget/app/section_title_widget.dart';
import 'package:fscore/widget/logos/arbitre_logo_widget.dart';
import 'package:fscore/widget/modals/confirm_dialog_widget.dart';
import 'package:fscore/widget_pages/arbitre_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ArbitreListWidget extends StatefulWidget {
  final CompositionSousCollection compositionSousCollection;
  final CompostitionWidgetType compostitionWidgetType;
  const ArbitreListWidget(
      {super.key,
      required this.compositionSousCollection,
      required this.compostitionWidgetType});

  @override
  State<ArbitreListWidget> createState() => _ArbitreListWidgetState();
}

class _ArbitreListWidgetState extends State<ArbitreListWidget> {
  _onDismisse(BuildContext context, ArbitreComposition composition) async {
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
        setState(() {
          widget.compositionSousCollection
              .removeArbitreComposition(composition.idComposition);
        });
      }
      String message = res ? 'Supprimé' : 'Echec de suppression!';
      await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Durations.extralong4,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SectionTitleWidget(title: 'Arbitres'),
          widget.compositionSousCollection.arbitres.isEmpty &&
                  widget.compostitionWidgetType !=
                      CompostitionWidgetType.setting
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Pas d\'arbitre disponible !'),
                  ),
                )
              : Column(children: [
                  ...widget.compositionSousCollection.arbitres
                      .map((e) => CompositionArbitreListTileWidget(
                            update: () => setState(() {}),
                            idEdition: widget.compositionSousCollection.game
                                .groupe.codeEdition,
                            onDismisse: (p0) => setState(() {
                              _onDismisse(context, p0);
                            }),
                            composition: e,
                            compostitionWidgetType:
                                widget.compostitionWidgetType,
                          ))
                      .toList(),
                  if (widget.compostitionWidgetType ==
                      CompostitionWidgetType.setting)
                    OutlinedButton(
                        onPressed: () {
                          setState(() {
                            widget.compositionSousCollection.arbitres
                                .add(kArbitreComposition.copyWith(
                              idGame:
                                  widget.compositionSousCollection.game.idGame,
                            ));
                          });
                        },
                        child: Text('Ajouter')),
                ]),
        ],
      ),
    );
  }
}

class CompositionArbitreListTileWidget extends StatelessWidget {
  final ArbitreComposition composition;
  final Function()? update;
  final String idEdition;
  final CompostitionWidgetType compostitionWidgetType;
  final Function(ArbitreComposition) onDismisse;
  const CompositionArbitreListTileWidget({
    super.key,
    required this.composition,
    required this.compostitionWidgetType,
    required this.onDismisse,
    required this.idEdition,
    required this.update,
  });

  void _onTap(BuildContext context) async {
    final bool check = await context
        .read<ArbitreProvider>()
        .checkArbitre(composition.idArbitre);
    if (check) {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ArbitreDetails(id: composition.idArbitre)));
    }
  }

  void _onDoubleTap(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ArbitreFormWidget(
              idEdition: idEdition,
              composition: composition,
            )));
    update!();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      onDoubleTap: compostitionWidgetType == CompostitionWidgetType.setting
          ? () => _onDoubleTap(context)
          : null,
      child: Slidable(
        key: ValueKey(composition.idComposition),
        enabled: compostitionWidgetType == CompostitionWidgetType.setting,
        startActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: (context) => onDismisse(composition),
              icon: Icons.delete,
              foregroundColor: Colors.red,
            ),
          ],
        ),
        child: ListTile(
          leading: SizedBox(
              width: 50,
              height: 50,
              child: ArbitreImageLogoWidget(url: composition.imageUrl)),
          title: Text(composition.nom),
          subtitle: Text(composition.role),
          trailing: Icon(
            composition.role == 'assistant'
                ? Icons.flag
                : composition.role == 'principale'
                    ? Icons.sports
                    : composition.role == 'var'
                        ? Icons.tv
                        : Icons.settings_backup_restore_outlined,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
