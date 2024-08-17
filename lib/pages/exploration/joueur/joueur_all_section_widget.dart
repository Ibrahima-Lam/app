import 'package:app/models/participant.dart';
import 'package:app/models/joueur.dart';
import 'package:app/pages/exploration/joueur/joueur_tile_widget.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/app/favori_title_widget.dart';
import 'package:flutter/material.dart';

class JoueurAllSectionWidget extends StatelessWidget {
  final JoueurProvider joueurProvider;
  final TextEditingController controller;
  final Participant participant;

  const JoueurAllSectionWidget({
    super.key,
    required this.joueurProvider,
    required this.controller,
    required this.participant,
  });

  @override
  Widget build(BuildContext context) {
    List<Joueur> joueurs = joueurProvider.joueurs
        .where((element) => element.idParticipant == participant.idParticipant)
        .toList()
      ..sort((a, b) => ((b.rating ?? 0) - (a.rating ?? 0)).toInt());
    if (controller.text.isNotEmpty) {
      joueurs = joueurs
          .where((element) => element.nomJoueur
              .toUpperCase()
              .contains(controller.text.toUpperCase()))
          .toList();
    }
    return joueurs.isEmpty
        ? Container(
            height: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(controller.text.isEmpty
                  ? 'Pas de Joueur disponible!'
                  : 'Pas de correspondance!'),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                FavoriTitleWidget(
                  title: controller.text.isEmpty ? 'Tous' : "Recherche",
                  icon: SizedBox(
                    width: 75,
                    height: 35,
                    child: controller.text.isEmpty
                        ? Row(
                            children: [
                              Icon(Icons.star),
                              Icon(Icons.star),
                              Icon(Icons.star_border),
                            ],
                          )
                        : SizedBox(
                            width: 35, height: 35, child: Icon(Icons.search)),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: joueurs
                          .map((e) => JoueurHorizontalTileWidget(
                                joueur: e,
                              ))
                          .toList(),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
