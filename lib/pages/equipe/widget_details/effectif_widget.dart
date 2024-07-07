import 'package:app/models/coachs/coach.dart';
import 'package:app/models/joueur.dart';
import 'package:app/providers/coach_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/coach_list_tile_widget.dart';
import 'package:app/widget/joueur_widget.dart';
import 'package:app/widget/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EffectifWidget extends StatelessWidget {
  final String idParticipant;
  const EffectifWidget({super.key, required this.idParticipant});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EffectifCoachSectionWidget(
            idParticipant: idParticipant,
          ),
          EffectifJoueurSectionWidget(
            idParticipant: idParticipant,
          ),
        ],
      ),
    );
  }
}

class EffectifCoachSectionWidget extends StatelessWidget {
  final String idParticipant;

  const EffectifCoachSectionWidget({
    super.key,
    required this.idParticipant,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<CoachProvider>().getData(),
        builder: (context, snapshot) {
          return Consumer<CoachProvider>(builder: (context, val, child) {
            final Coach? coach = val.getCoachByEquipe(idParticipant);

            return coach == null
                ? const SizedBox()
                : Card(
                    child: Column(
                      children: [
                        SectionTitleWidget(title: 'Entraineur'),
                        CoachListTileWidget(coach: coach),
                      ],
                    ),
                  );
          });
        });
  }
}

class EffectifJoueurSectionWidget extends StatelessWidget {
  final String idParticipant;

  const EffectifJoueurSectionWidget({
    super.key,
    required this.idParticipant,
  });

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
            return Container(
              height: MediaQuery.sizeOf(context).height * .75,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Consumer<JoueurProvider>(builder: (context, val, child) {
            List<Joueur> joueurs = snapshot.data ?? [];

            return joueurs.isEmpty
                ? Container(
                    height: MediaQuery.sizeOf(context).height * .75,
                    child: const Center(
                      child:
                          Text('Pas de joueur disponible pour cette equipe!'),
                    ),
                  )
                : Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
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
