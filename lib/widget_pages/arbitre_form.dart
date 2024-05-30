import 'package:app/models/composition.dart';
import 'package:app/widget/dropdown_menu_widget.dart';
import 'package:app/widget/elevated_button_widget.dart';
import 'package:app/widget/text_field_widget.dart';
import 'package:flutter/material.dart';

class ArbitreFormWidget extends StatefulWidget {
  final ArbitreComposition composition;
  const ArbitreFormWidget({super.key, required this.composition});

  @override
  State<ArbitreFormWidget> createState() => _ArbitreFormWidgetState();
}

class _ArbitreFormWidgetState extends State<ArbitreFormWidget> {
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
                Text('Role'),
                DropDownMenuWidget(
                    onChanged: (val) {
                      setState(() {
                        widget.composition.role = val!;
                      });
                    },
                    tab: ['principale', 'assistant', '4 eme', 'var'],
                    value: widget.composition.role),
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
