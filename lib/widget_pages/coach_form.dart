import 'package:app/models/composition.dart';
import 'package:app/widget/composition_events_widget.dart';
import 'package:app/widget/dropdown_menu_widget.dart';
import 'package:app/widget/elevated_button_widget.dart';
import 'package:app/widget/text_field_widget.dart';
import 'package:flutter/material.dart';

class CoachFormWidget extends StatefulWidget {
  final CoachComposition composition;
  const CoachFormWidget({super.key, required this.composition});

  @override
  State<CoachFormWidget> createState() => _CoachFormWidgetState();
}

class _CoachFormWidgetState extends State<CoachFormWidget> {
  late final TextEditingController nomEditingController;

  @override
  void initState() {
    nomEditingController = TextEditingController(text: widget.composition.nom);
    super.initState();
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
            TextFieldWidget(
                textEditingController: nomEditingController,
                hintText: 'Entrer le nom'),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CardWidget(),
                DropDownMenuWidget(
                    onChanged: (val) {
                      setState(() {
                        widget.composition.jaune = val!;
                      });
                    },
                    tab: [0, 1, 2],
                    value: widget.composition.jaune),
              ],
            ),
            const SizedBox(
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
                        widget.composition.rouge = val!;
                      });
                    },
                    tab: [0, 1],
                    value: widget.composition.rouge),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButtonWidget(
              onPressed: () async {
                setState(() {
                  widget.composition.nom = nomEditingController.text;
                });
                Navigator.pop(context, widget.composition);
              },
            )
          ],
        ),
      ),
    );
  }
}
