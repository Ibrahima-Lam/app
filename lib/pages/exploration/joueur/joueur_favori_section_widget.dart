import 'package:app/models/participant.dart';
import 'package:app/models/joueur.dart';
import 'package:app/pages/exploration/joueur/joueur_tile_widget.dart';
import 'package:app/providers/favori_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/app/favori_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoueurFavoriSectionWidget extends StatelessWidget {
  final JoueurProvider joueurProvider;
  final Participant participant;

  const JoueurFavoriSectionWidget({
    super.key,
    required this.joueurProvider,
    required this.participant,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriProvider>(
      builder: (context, favoriProvider, child) {
        List<Joueur> joueurs = joueurProvider.joueurs
            .where((element) =>
                element.idParticipant == participant.idParticipant &&
                favoriProvider.joueurs.any(
                  (e) => e == element.idJoueur,
                ))
            .toList();
        return joueurs.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    FavoriTitleWidget(
                      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                    ),
                    JoueurHorizontalListWidget(joueurs: joueurs),
                  ],
                ),
              );
      },
    );
  }
}

class JoueurHorizontalListWidget extends StatelessWidget {
  final List<Joueur> joueurs;

  const JoueurHorizontalListWidget({super.key, required this.joueurs});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: joueurs
                .map((e) => JoueurVerticalTileWidget(
                      joueur: e,
                    ))
                .expand((element) sync* {
              yield SizedBox(width: 10);
              yield element;
              yield SizedBox(width: 10);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
