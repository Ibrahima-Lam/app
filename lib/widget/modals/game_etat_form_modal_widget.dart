// ignore_for_file: must_be_immutable

import 'package:app/core/extension/string_extension.dart';
import 'package:app/models/gameEvent.dart';
import 'package:app/widget/form/elevated_button_widget.dart';
import 'package:app/widget/form/text_field_widget.dart';
import 'package:flutter/material.dart';

class GameTimerFormModalWidget extends StatefulWidget {
  final TimerEvent? timer;
  GameTimerFormModalWidget({super.key, required this.timer});

  @override
  State<GameTimerFormModalWidget> createState() =>
      _GameTimerFormModalWidgetState();
}

class _GameTimerFormModalWidgetState extends State<GameTimerFormModalWidget> {
  late final TimerEvent timerEvent;
  late final TextEditingController durationController;
  late final TextEditingController initialController;
  late final TextEditingController retardController;
  late final TextEditingController extraController;
  late final TextEditingController etatController;
  DateTime? date;
  TimeOfDay? time;
  @override
  void initState() {
    timerEvent = widget.timer?.copyWith() ??
        TimerEvent(
            start: DateTime.now().toString(),
            duration: 0,
            initial: 0,
            retard: 0,
            extra: 0,
            etat: 'direct');
    initialController =
        TextEditingController(text: (timerEvent.initial).toString());
    durationController =
        TextEditingController(text: (timerEvent.duration ?? '').toString());
    retardController =
        TextEditingController(text: (timerEvent.retard ?? '').toString());
    extraController =
        TextEditingController(text: (timerEvent.extra ?? '').toString());
    etatController =
        TextEditingController(text: (timerEvent.etat ?? '').toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text('Supprimer')),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.clear)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Date de debut'),
                Text(timerEvent.start ?? ""),
                IconButton(
                    onPressed: () async {
                      date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      time = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (date != null && time != null) {
                        date = date!.add(
                            Duration(hours: time!.hour, minutes: time!.minute));
                        setState(() {
                          timerEvent.start = date.toString();
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_month)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: Text('Temps initial')),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: TextFieldWidget(
                        textEditingController: initialController,
                        hintText: 'Temps initial',
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: Text(' Duree')),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: TextFieldWidget(
                        textEditingController: durationController,
                        hintText: 'Duree',
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: Text('Temps retard')),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: TextFieldWidget(
                        textEditingController: retardController,
                        hintText: 'Temps retard',
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: Text('Temps additionnel')),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: TextFieldWidget(
                        textEditingController: extraController,
                        hintText: 'Temps additionnel',
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: Text('Etat')),
                  SizedBox(
                    width: 150,
                    height: 100,
                    child:
                        EtatDropDownMenuWidget(etatController: etatController),
                  ),
                ],
              ),
            ),
            ElevatedButtonWidget(
              onPressed: () {
                timerEvent.initial = int.parse(initialController.text);
                timerEvent.duration = int.parse(durationController.text);
                timerEvent.retard = int.parse(retardController.text);
                timerEvent.extra = int.parse(extraController.text);
                timerEvent.etat = etatController.text;
                Navigator.pop(context, timerEvent);
              },
            )
          ],
        );
      },
    );
  }
}

class GameEtatFormModalWidget extends StatefulWidget {
  final String etat;
  GameEtatFormModalWidget({super.key, required this.etat});

  @override
  State<GameEtatFormModalWidget> createState() =>
      _GameEtatFormModalWidgetState();
}

class _GameEtatFormModalWidgetState extends State<GameEtatFormModalWidget> {
  late final TextEditingController etatController;
  @override
  void initState() {
    etatController = TextEditingController(text: widget.etat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text('Supprimer')),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.clear)),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: Text('Etat')),
                  SizedBox(
                    width: 150,
                    height: 100,
                    child:
                        EtatDropDownMenuWidget(etatController: etatController),
                  ),
                ],
              ),
            ),
            ElevatedButtonWidget(
              onPressed: () {
                Navigator.pop(context, etatController.text);
              },
            )
          ],
        );
      },
    );
  }
}

class EtatDropDownMenuWidget extends StatelessWidget {
  final TextEditingController etatController;
  const EtatDropDownMenuWidget({super.key, required this.etatController});
  final List<String> values = const [
    'avant',
    'direct',
    'pause',
    'termine',
    'annule',
    'reporte',
    'arrete'
  ];
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
        initialSelection: etatController.text,
        controller: etatController,
        dropdownMenuEntries: values
            .map((e) => DropdownMenuEntry(value: e, label: e.capitalize()))
            .toList());
  }
}
