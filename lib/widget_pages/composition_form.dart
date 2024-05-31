import 'package:app/models/composition.dart';
import 'package:app/models/joueur.dart';
import 'package:app/widget/elevated_button_widget.dart';
import 'package:app/widget/bottom_modal_joueur_list_widget.dart';
import 'package:app/widget/text_field_widget.dart';
import 'package:flutter/material.dart';

class CompositionForm extends StatefulWidget {
  final JoueurComposition composition;
  const CompositionForm({super.key, required this.composition});

  @override
  State<CompositionForm> createState() => _CompositionFormState();
}

class _CompositionFormState extends State<CompositionForm> {
  late final TextEditingController nomController;

  late final TextEditingController numeroController;

  @override
  void initState() {
    nomController = TextEditingController(text: widget.composition.nom);
    numeroController =
        TextEditingController(text: (widget.composition.numero).toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              ElevatedButtonWidget(
                onPressed: () async {
                  setState(() {
                    widget.composition.nom = nomController.text;
                    widget.composition.numero =
                        int.parse(numeroController.text);
                  });
                  Navigator.pop(context, widget.composition);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
