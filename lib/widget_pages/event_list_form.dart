// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:app/core/extension/string_extension.dart';
import 'package:app/models/event.dart';
import 'package:app/models/joueur.dart';
import 'package:app/widget/composition_events_widget.dart';
import 'package:app/widget/elevated_button_widget.dart';
import 'package:app/widget/bottom_modal_joueur_list_widget.dart';
import 'package:app/widget/text_field_widget.dart';
import 'package:flutter/material.dart';

class EventListForm extends StatefulWidget {
  final Event event;
  const EventListForm({super.key, required this.event});

  @override
  State<EventListForm> createState() => _EventListFormState();
}

class _EventListFormState extends State<EventListForm> {
  late final TextEditingController nomController;
  late final TextEditingController minuteController;
  late final TextEditingController nomTargetController;

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
              onPressed: () {
                widget.event.nom = nomController.text;
                widget.event.minute = minuteController.text;
                widget.event.nomTarget = nomTargetController.text;
                Navigator.pop(context, widget.event);
              },
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
