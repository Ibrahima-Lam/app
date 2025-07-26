import 'package:fscore/models/composition.dart';
import 'package:fscore/models/joueur.dart';
import 'package:fscore/providers/composition_provider.dart';
import 'package:fscore/widget/form/dropdown_menu_app_form_widget.dart';
import 'package:fscore/widget/form/elevated_button_widget.dart';
import 'package:fscore/widget/modals/bottom_modal_joueur_list_widget.dart';
import 'package:fscore/widget/form/text_field_widget.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompositionForm extends StatefulWidget {
  final JoueurComposition composition;
  const CompositionForm({super.key, required this.composition});

  @override
  State<CompositionForm> createState() => _CompositionFormState();
}

class _CompositionFormState extends State<CompositionForm> {
  late final TextEditingController nomController;

  late final TextEditingController numeroController;
  late final TextEditingController capitaineController;

  @override
  void initState() {
    nomController = TextEditingController(text: widget.composition.nom);
    numeroController =
        TextEditingController(text: (widget.composition.numero).toString());
    capitaineController =
        TextEditingController(text: widget.composition.isCapitaine.toString());
    super.initState();
  }

  void _onSubmit() async {
    setState(() {
      widget.composition.nom = nomController.text;
      widget.composition.numero = int.parse(numeroController.text);
      widget.composition.isCapitaine = bool.parse(capitaineController.text);
    });
    bool result = await context
        .read<CompositionProvider>()
        .setComposition(widget.composition.idComposition, widget.composition);
    if (result) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Composition'),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                IconButton(
                    onPressed: () async {
                      Joueur? joueur = await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return BottomModalSheetJoueurListWidget(
                            idParticipant: widget.composition.idParticipant,
                          );
                        },
                      );
                      if (joueur != null) {
                        nomController.text = joueur.nomJoueur;
                        widget.composition.idJoueur = joueur.idJoueur;
                        widget.composition.imageUrl = joueur.imageUrl;
                      }
                    },
                    icon: Icon(Icons.list)),
                TextFieldWidget(
                    textEditingController: nomController,
                    hintText: 'Entrer le nom'),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                    textEditingController: numeroController,
                    hintText: 'Entrer le numero'),
                const SizedBox(
                  height: 10,
                ),
                DropDownMenuAppFormWidget(
                    entries: {'oui': true, 'non': false},
                    title: 'Capitaine',
                    controller: capitaineController),
                ElevatedButtonWidget(
                  onPressed: _onSubmit,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
