import 'package:app/models/joueur.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/joueur/joueur_widget.dart';
import 'package:app/widget/form/text_search_field_widget.dart';
import 'package:app/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoueurPage extends StatelessWidget {
  JoueurPage({super.key});

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Joueurs'),
        ),
        body: Container(
          child: FutureBuilder(
            future: context.read<JoueurProvider>().getJoueurs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Erreur!'),
                );
              }
              return Consumer<JoueurProvider>(builder: (context, value, child) {
                List<Joueur> joueurs = value.joueurs;
                return joueurs.length == 0
                    ? const Center(
                        child: Text('Pas de données!'),
                      )
                    : Column(
                        children: [
                          TextSearchFieldWidget(
                              textEditingController: textEditingController,
                              hintText: 'Recherche de joueur...'),
                          Expanded(
                              child: Card(
                            child: ListenableBuilder(
                                listenable: textEditingController,
                                builder: (context, child) {
                                  joueurs = textEditingController
                                          .text.isNotEmpty
                                      ? joueurs
                                          .where((element) => element.nomJoueur
                                              .toUpperCase()
                                              .contains(textEditingController
                                                  .text
                                                  .toUpperCase()))
                                          .toList()
                                      : value.joueurs;

                                  return Scrollbar(
                                    child: ListView.builder(
                                      itemCount: joueurs.length,
                                      itemBuilder: (context, index) =>
                                          JoueurListTileWidget(
                                        joueur: joueurs[index],
                                        showEquipe: true,
                                      ),
                                    ),
                                  );
                                }),
                          ))
                        ],
                      );
              });
            },
          ),
        ),
      ),
    );
  }
}
