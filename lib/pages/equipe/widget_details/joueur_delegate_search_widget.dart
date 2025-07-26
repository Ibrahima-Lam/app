import 'package:fscore/models/joueur.dart';
import 'package:fscore/providers/joueur_provider.dart';
import 'package:fscore/widget/joueur/joueur_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoueurDelegateSearch extends SearchDelegate {
  final String idParticipant;
  JoueurDelegateSearch({required this.idParticipant});
  List<Joueur> joueurs = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return query.isEmpty
        ? null
        : [
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                buildSuggestions(context);
              },
            )
          ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.navigate_before),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(
      child: Text(''),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<JoueurProvider>(builder: (context, val, child) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder(
              future: joueurs.isNotEmpty
                  ? null
                  : context
                      .read<JoueurProvider>()
                      .getJoueursBy(idParticipant: idParticipant),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erreur de chargement!'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                joueurs = snapshot.data ?? [];
                List<Joueur> elements = query.isEmpty
                    ? []
                    : joueurs
                        .where((element) => element.nomJoueur
                            .toUpperCase()
                            .contains(query.toUpperCase()))
                        .toList();
                return elements.isEmpty
                    ? SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(query.isEmpty
                              ? 'Taper votre recherche!'
                              : 'Pas de correspondance !'),
                        ),
                      )
                    : ListView.builder(
                        itemCount: elements.length,
                        itemBuilder: (context, index) {
                          final Joueur joueur = elements[index];
                          return JoueurListTileWidget(
                            joueur: joueur,
                          );
                        },
                      );
              }),
        ),
      );
    });
  }
}
