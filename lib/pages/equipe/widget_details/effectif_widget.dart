import 'package:app/models/joueur.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/joueur_widget.dart';
import 'package:app/widget/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EffectifWidget extends StatelessWidget {
  final String idParticipant;
  const EffectifWidget({super.key, required this.idParticipant});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        EffectifJoueurSectionWidget(
          idParticipant: idParticipant,
        )
      ],
    );
  }
}

class EffectifJoueurSectionWidget extends StatelessWidget {
  final String idParticipant;
  const EffectifJoueurSectionWidget({super.key, required this.idParticipant});

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
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }

          return Consumer<JoueurProvider>(builder: (context, val, child) {
            List<Joueur> joueurs = snapshot.data ?? [];
            return joueurs.isEmpty
                ? const SizedBox()
                : Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    child: Column(
                      children: [
                        SectionTitleWidget(title: "Joueurs"),
                        ...joueurs
                            .map((e) => JoueurListTileWidget(joueur: e))
                            .toList()
                      ],
                    ),
                  );
          });
        });
  }
}
