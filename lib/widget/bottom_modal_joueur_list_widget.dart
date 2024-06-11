import 'package:app/models/joueur.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/joueur_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomModalSheetJoueurListWidget extends StatelessWidget {
  final String idParticipant;
  const BottomModalSheetJoueurListWidget(
      {super.key, required this.idParticipant});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context
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
          return Consumer<JoueurProvider>(builder: (context, val, child) {
            List<Joueur> joueurs = snapshot.data ?? [];
            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.8,
              builder: (context, scrollController) {
                return joueurs.isEmpty
                    ? Center(
                        child: Text('Pas de joueurs disponible cette équipe !'),
                      )
                    : Container(
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
