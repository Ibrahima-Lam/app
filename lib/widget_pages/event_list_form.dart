// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:app/core/extension/string_extension.dart';
import 'package:app/models/composition.dart';
import 'package:app/models/event.dart';
import 'package:app/models/joueur.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/widget/bottom_modal_composition_list_widget.dart';
import 'package:app/widget/composition_events_widget.dart';
import 'package:app/widget/confirm_dialog_widget.dart';
import 'package:app/widget/elevated_button_widget.dart';
import 'package:app/widget/bottom_modal_joueur_list_widget.dart';
import 'package:app/widget/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventListForm extends StatefulWidget {
  final Event event;
  final bool isNew;
  const EventListForm({super.key, required this.event, required this.isNew});

  @override
  State<EventListForm> createState() => _EventListFormState();
}

class _EventListFormState extends State<EventListForm> {
  late final TextEditingController nomController;
  late final TextEditingController minuteController;
  late final TextEditingController nomTargetController;
  JoueurComposition? composition;

  void _onSubmit() {
    widget.event.nom = nomController.text;
    widget.event.minute = minuteController.text;
    widget.event.nomTarget = nomTargetController.text;
    if (composition != null && widget.isNew) {
      if (widget.event is GoalEvent) ++composition!.but;
      if (widget.event is CardEvent) {
        (widget.event as CardEvent).isRed
            ? ++composition!.rouge
            : ++composition!.jaune;
      }
    }

    context.read<CompositionProvider>().notifyListeners();
    Navigator.pop(context, widget.event);
  }

  void _setCompostion([String? idComposition]) {
    composition = context
        .read<CompositionProvider>()
        .compositionCollection
        .getJoueurComposition(
            idGame: widget.event.idGame,
            idParticipant: widget.event.idParticipant,
            idJoueur: widget.event.idJoueur,
            idComposition: idComposition);
  }

  @override
  void initState() {
    nomController = TextEditingController(text: widget.event.nom);
    minuteController = TextEditingController(text: widget.event.minute);
    nomTargetController = TextEditingController(text: widget.event.nomTarget);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          CircleAvatar(
            radius: 20,
            child: widget.event is GoalEvent
                ? Icon(Icons.sports_soccer)
                : widget.event is CardEvent
                    ? (CardWidget(
                        isRed: (widget.event as CardEvent).isRed,
                      ))
                    : widget.event is RemplEvent
                        ? Icon(Icons.swap_vert)
                        : null,
          ),
          const SizedBox(
            width: 10.0,
          )
        ],
        title: Text(widget.event.type.capitalize()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFieldWidget(
              textEditingController: nomController,
              hintText: 'Entrer le nom',
              prefixIcon: IconButton(
                  onPressed: () async {
                    final JoueurComposition? compo = await showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          BottomModalSheetCompositionListWidget(
                              idParticipant: widget.event.idParticipant,
                              idGame: widget.event.idGame),
                    );
                    if (compo != null) {
                      final bool? check = await showDialog(
                          context: context,
                          builder: (context) => ConfirmDialogWidget(
                                title:
                                    'Confirmation de changement de l\'element',
                                content:
                                    'Voulez vous changer l\'element courant par cet element?',
                              ));
                      if (check == true) {
                        setState(() {
                          nomController.text = compo.nom;
                          widget.event.idJoueur = compo.idJoueur;
                          _setCompostion(compo.idComposition);
                          if (composition != null) {
                            composition?.idJoueur = compo.idJoueur;
                            composition?.nom = compo.nom;
                            composition?.idParticipant = compo.idParticipant;
                          }
                        });
                      }
                    }
                  },
                  icon: Icon(Icons.lightbulb_sharp)),
              suffixIcon: IconButton(
                  onPressed: () async {
                    final Joueur? joueur = await showModalBottomSheet(
                      context: context,
                      builder: (context) => BottomModalSheetJoueurListWidget(
                          idParticipant: widget.event.idParticipant),
                    );
                    if (joueur != null) {
                      setState(() {
                        nomController.text = joueur.nomJoueur;
                        widget.event.idJoueur = joueur.idJoueur;
                        _setCompostion();
                        if (composition != null) {
                          composition?.idJoueur = joueur.idJoueur;
                          composition?.nom = joueur.nomJoueur;
                          composition?.idParticipant = joueur.idParticipant;
                        }
                      });
                    }
                  },
                  icon: Icon(Icons.list)),
            ),
            const SizedBox(height: 10),
            TextFieldWidget(
                textEditingController: minuteController,
                hintText: 'Entrer les minutes'),
            const SizedBox(height: 10),
            NomTargetWidget(
                event: widget.event, nomTargetController: nomTargetController),
            const SizedBox(height: 10),
            ElevatedButtonWidget(
              onPressed: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

class NomTargetWidget extends StatelessWidget {
  final Event event;
  final TextEditingController nomTargetController;
  const NomTargetWidget(
      {super.key, required this.event, required this.nomTargetController});

  @override
  Widget build(BuildContext context) {
    if (event is CardEvent) {
      return Card(
        child: DropdownMenu(
            menuStyle: MenuStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white)),
            width: MediaQuery.sizeOf(context).width * .95,
            label: Text('Selectionner la cause'),
            enableSearch: true,
            controller: nomTargetController,
            initialSelection: nomTargetController.text,
            dropdownMenuEntries: [
              DropdownMenuEntry(value: 'faute', label: 'faute'),
              DropdownMenuEntry(value: 'discution', label: 'discution'),
            ]),
      );
    }
    final String hint = event is GoalEvent
        ? 'Entrer le passeur'
        : 'Entrer le nom du  remplacant';
    return StatefulBuilder(
      builder: (context, setState) {
        return TextFieldWidget(
          textEditingController: nomTargetController,
          hintText: hint,
          suffixIcon: IconButton(
              onPressed: () async {
                final Joueur? joueur = await showModalBottomSheet(
                  context: context,
                  builder: (context) => BottomModalSheetJoueurListWidget(
                      idParticipant: event.idParticipant),
                );
                if (joueur != null) {
                  setState(() {
                    nomTargetController.text = joueur.nomJoueur;
                    event.idTarget = joueur.idJoueur;
                  });
                }
              },
              icon: Icon(Icons.list)),
        );
      },
    );
  }
}
