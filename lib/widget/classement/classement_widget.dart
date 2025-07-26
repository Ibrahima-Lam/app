import 'package:fscore/models/participation.dart';
import 'package:fscore/models/stat.dart';
import 'package:fscore/providers/game_provider.dart';
import 'package:fscore/providers/groupe_provider.dart';
import 'package:fscore/providers/participation_provider.dart';
import 'package:fscore/service/stat_service.dart';
import 'package:fscore/widget/app/section_title_widget.dart';
import 'package:fscore/widget/classement/classement_toggle_botton_widget.dart';
import 'package:fscore/widget/classement/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassementWiget extends StatelessWidget {
  final String? title;
  final String codeEdition;
  final String? idGroupe;
  final String? idParticipant;
  final List<String>? targets;
  const ClassementWiget(
      {super.key,
      this.title,
      this.idGroupe,
      this.idParticipant,
      this.targets,
      required this.codeEdition});
  factory ClassementWiget.equipe(
          {String? title,
          required String idParticipant,
          required String codeEdition,
          bool isTarget = false}) =>
      ClassementWiget(
        title: title,
        idParticipant: idParticipant,
        codeEdition: codeEdition,
        targets: [if (isTarget) idParticipant],
      );

  Future<List<Stat>> _getStat(BuildContext context) async {
    List<Stat> stats = [];
    if (idGroupe != null) {
      stats = await StatService(context: context, codeEdition: codeEdition)
          .getStatByGroupe(idGroupe: idGroupe!);
    } else if (idParticipant != null) {
      stats = await StatService(context: context, codeEdition: codeEdition)
          .getStatByEquipe(idParticipant: idParticipant!);
    }
    return stats;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, gameProvider, _) {
      return FutureBuilder(
          future: _getStat(context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Erreur!'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final List<Stat> stat = snapshot.data ?? [];
            int selected = 0;
            return Consumer2<ParticipationProvider, GroupeProvider>(builder:
                (context, participationProvider, groupeProvider, child) {
              final Participation? participation =
                  participationProvider.getParticipationByGroupeOrEquipe(
                      idParticipant: idParticipant, idGroupe: idGroupe);

              return StatefulBuilder(builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ClassementToggleBottonWidget(
                          onSelected: (index) {
                            setState(() => selected = index);
                          },
                          selected: selected),
                      Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        color: Colors.white,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              SectionTitleWidget(
                                  title: title ??
                                      'Groupe ${participation?.groupe.nomGroupe ?? ''}'),
                              TableWidget(
                                targets: targets,
                                stats: stat,
                                expand: selected == 0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
            });
          });
    });
  }
}
