import 'package:app/models/composition.dart';
import 'package:app/models/joueur.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/elevated_button_widget.dart';
import 'package:app/widget/joueur_widget.dart';
import 'package:app/widget/text_field_widget.dart';
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
                        return BottomSheetWidget(
                          composition: widget.composition,
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

class BottomSheetWidget extends StatelessWidget {
  final JoueurComposition composition;
  const BottomSheetWidget({super.key, required this.composition});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context
            .read<JoueurProvider>()
            .getJoueursBy(idParticipant: composition.idParticipant),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur de chargement!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
          return Consumer<JoueurProvider>(builder: (context, val, child) {
            List<Joueur> joueurs = snapshot.data ?? [];
            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.8,
              builder: (context, scrollController) {
                return Container(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: joueurs.length,
                    itemBuilder: (context, index) {
                      Joueur joueur = joueurs[index];
                      return JoueurListTileWidget(
                        joueur: joueur,
                        onTap: () => Navigator.pop(context, joueur),
                      );
                    },
                  ),
                );
              },
            );
          });
        });
  }
}
