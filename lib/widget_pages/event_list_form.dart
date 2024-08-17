// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:app/core/extension/string_extension.dart';
import 'package:app/models/composition.dart';
import 'package:app/models/event.dart';
import 'package:app/models/joueur.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/widget/modals/bottom_modal_composition_list_widget.dart';
import 'package:app/widget/events/composition_events_widget.dart';
import 'package:app/widget/modals/confirm_dialog_widget.dart';
import 'package:app/widget/form/elevated_button_widget.dart';
import 'package:app/widget/modals/bottom_modal_joueur_list_widget.dart';
import 'package:app/widget/form/text_field_widget.dart';
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
  JoueurComposition? composition2;

  void _onSubmit() async {
    widget.event.nom = nomController.text;
    List<Event> evs = await context
        .read<GameEventListProvider>()
        .getGameEvents(idGame: widget.event.idGame);
    final bool chk = evs.any((element) =>
        element.idJoueur == widget.event.idJoueur &&
        element.nom != nomController.text);
    if (chk) {
      final String? nom = await showDialog(
        context: context,
        builder: (context) => EventSimpleDialogWidget(event: widget.event),
      );
      if (nom != null) {
        List<Event> evs = context
            .read<GameEventListProvider>()
            .getJoueurGameEvent(
                idGame: widget.event.idGame, idJoueur: widget.event.idJoueur);
        nomController.text = nom;
        context.read<GameEventListProvider>().setJoueurGameEventNom(evs, nom);
      } else
        return;
    }

    widget.event.nom = nomController.text;
    widget.event.minute = minuteController.text;
    widget.event.nomTarget = nomTargetController.text;

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

  void _setCompostion2({
    String? idComposition,
    required String idGame,
    required String idParticipant,
    required String idJoueur,
  }) {
    composition2 = context
        .read<CompositionProvider>()
        .compositionCollection
        .getJoueurComposition(
            idGame: idGame,
            idParticipant: idParticipant,
            idJoueur: idJoueur,
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
                                title: 'changer  l\'élément',
                                content:
                                    'Voulez vous changer l\'élément courant par cet élément?',
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
                            composition?.idGame = compo.idGame;
                            composition?.imageUrl = compo.imageUrl;
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
                          composition?.imageUrl = joueur.imageUrl;
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
              event: widget.event,
              nomTargetController: nomTargetController,
              composition: composition2,
              setComposition: _setCompostion2,
            ),
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
  final JoueurComposition? composition;
  final TextEditingController nomTargetController;
  final Function({
    String? idComposition,
    required String idGame,
    required String idParticipant,
    required String idJoueur,
  }) setComposition;
  const NomTargetWidget(
      {super.key,
      required this.event,
      required this.nomTargetController,
      required this.composition,
      required this.setComposition});

  @override
  Widget build(BuildContext context) {
    if (event is CardEvent) {
      return Card(
        child: DropdownMenu(
            menuStyle: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white)),
            width: MediaQuery.of(context).size.width * .95,
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
          prefixIcon: IconButton(
              onPressed: () async {
                final JoueurComposition? compo = await showModalBottomSheet(
                  context: context,
                  builder: (context) => BottomModalSheetCompositionListWidget(
                      idParticipant: event.idParticipant, idGame: event.idGame),
                );
                if (compo != null) {
                  final bool? check = await showDialog(
                      context: context,
                      builder: (context) => ConfirmDialogWidget(
                            title: 'changer de l\'élément',
                            content:
                                'Voulez vous changer l\'élément courant par cet élément?',
                          ));
                  if (check == true) {
                    setState(() {
                      nomTargetController.text = compo.nom;
                      event.idJoueur = compo.idJoueur;
                      setComposition(
                        idComposition: compo.idComposition,
                        idGame: compo.idGame,
                        idParticipant: compo.idParticipant,
                        idJoueur: compo.idJoueur,
                      );
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
                      idParticipant: event.idParticipant),
                );
                if (joueur != null) {
                  setState(() {
                    nomTargetController.text = joueur.nomJoueur;
                    event.idTarget = joueur.idJoueur;
                    setComposition(
                      idGame: event.idGame,
                      idParticipant: joueur.idParticipant,
                      idJoueur: joueur.idJoueur,
                    );
                    if (composition != null) {
                      composition?.idJoueur = joueur.idJoueur;
                      composition?.nom = joueur.nomJoueur;
                      composition?.idParticipant = joueur.idParticipant;
                    }
                  });
                }
              },
              icon: Icon(Icons.list)),
        );
      },
    );
  }
}

class EventSimpleDialogWidget extends StatelessWidget {
  final Event event;
  const EventSimpleDialogWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameEventListProvider>(builder: (context, val, child) {
      List<Event> events = val.getJoueurGameEvent(
          idGame: event.idGame, idJoueur: event.idJoueur);
      events =
          events.where((element) => element.idEvent != event.idEvent).toList();
      events.add(event);
      Set ids = Set();
      events = events.where((element) => ids.add(element.nom)).toList();
      return SimpleDialog(
        title: Text('Choisir un seul nom pour ce joueur'),
        children: [
          ...events.map((e) => ListTile(
                onTap: () => Navigator.pop(context, e.nom),
                title: Text(e.nom),
              ))
        ],
      );
    });
  }
}
