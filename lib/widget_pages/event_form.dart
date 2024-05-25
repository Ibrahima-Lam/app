import 'package:app/models/composition.dart';
import 'package:app/widget/composition_events_widget.dart';
import 'package:flutter/material.dart';

class EventFormWidget extends StatefulWidget {
  final JoueurComposition composition;
  const EventFormWidget({super.key, required this.composition});

  @override
  State<EventFormWidget> createState() => _EventFormWidgetState();
}

class _EventFormWidgetState extends State<EventFormWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.composition.nom),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Buts'),
                DropDownMenuWidget(
                    onChanged: (val) {
                      setState(() {
                        widget.composition.but = val as int;
                      });
                    },
                    tab: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                    value: widget.composition.but)
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CardWidget(),
                DropDownMenuWidget(
                    onChanged: (val) {
                      setState(() {
                        widget.composition.jaune = val as int;
                      });
                    },
                    tab: [0, 1, 2],
                    value: widget.composition.jaune)
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CardWidget(
                  isRed: true,
                ),
                DropDownMenuWidget(
                    onChanged: (val) {
                      setState(() {
                        widget.composition.rouge = val as int;
                      });
                    },
                    tab: [0, 1],
                    value: widget.composition.rouge)
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CapitaineWidget(),
                DropDownMenuWidget(
                    onChanged: (val) {
                      setState(() {
                        widget.composition.isCapitaine = val as bool;
                      });
                    },
                    tab: [false, true],
                    value: widget.composition.isCapitaine)
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class DropDownMenuWidget<T> extends StatelessWidget {
  final void Function(T?)? onChanged;
  final List<T> tab;
  final T value;
  const DropDownMenuWidget(
      {super.key,
      required this.onChanged,
      required this.tab,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: value,
        items: tab
            .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
            .toList(),
        onChanged: onChanged);
  }
}
