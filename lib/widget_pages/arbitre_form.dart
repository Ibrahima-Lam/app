import 'package:app/models/arbitres/arbitre.dart';
import 'package:app/models/composition.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/widget/form/dropdown_menu_widget.dart';
import 'package:app/widget/form/elevated_button_widget.dart';
import 'package:app/widget/form/text_field_widget.dart';
import 'package:app/widget/modals/bottom_modal_arbitre_list_widget.dart';
import 'package:app/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArbitreFormWidget extends StatefulWidget {
  final String idEdition;
  final ArbitreComposition composition;
  const ArbitreFormWidget(
      {super.key, required this.composition, required this.idEdition});

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

  void _onPressed() async {
    final Arbitre? arbitre = await showModalBottomSheet(
        context: context,
        builder: (context) =>
            BottomModalArbitreListWidget(idEdition: widget.idEdition));
    if (arbitre is Arbitre) {
      widget.composition.idArbitre = arbitre.idArbitre;
      widget.composition.nom = arbitre.nomArbitre;
      nomEditingController.text = arbitre.nomArbitre;
      widget.composition.imageUrl = arbitre.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.composition.nom),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextFieldWidget(
                  prefixIcon:
                      IconButton(onPressed: _onPressed, icon: Icon(Icons.list)),
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
                  final bool result = await context
                      .read<CompositionProvider>()
                      .setComposition(
                          widget.composition.idComposition, widget.composition);
                  if (result) Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
