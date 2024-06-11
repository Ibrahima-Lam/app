import 'package:app/models/joueur.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/joueur_widget.dart';
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
      return FutureBuilder(
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
            return ListView.builder(
              itemCount: elements.length,
              itemBuilder: (context, index) {
                final Joueur joueur = elements[index];
                return JoueurListTileWidget(
                  joueur: joueur,
                );
              },
            );
          });
    });
  }
}
