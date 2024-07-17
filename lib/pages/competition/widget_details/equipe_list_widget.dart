import 'package:app/core/enums/competition_phase_enum.dart';
import 'package:app/core/enums/competition_type.dart';
import 'package:app/models/competition.dart';
import 'package:app/models/groupe.dart';
import 'package:app/models/participant.dart';
import 'package:app/models/participation.dart';
import 'package:app/providers/groupe_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/providers/participation_provider.dart';
import 'package:app/widget/equipe/equipe_widget.dart';
import 'package:app/widget/app/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EquipeListWidget extends StatelessWidget {
  final Competition competition;
  const EquipeListWidget({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    if (competition.type.type == CompetitionType.coupe) {
      return ParticipationWidget(competition: competition);
    }
    return ParticipantWidget(competition: competition);
  }
}

// ignore: must_be_immutable
class ParticipationWidget extends StatelessWidget {
  final Competition competition;
  ParticipationWidget({super.key, required this.competition});
  List<Groupe> groupes = [];
  List<Participation> participations = [];

  Future<bool> _getData(BuildContext context) async {
    GroupeProvider groupeProvider = await context.read<GroupeProvider>()
      ..getGroupes();
    groupes = groupeProvider.getGroupesBy(
        edition: competition.codeEdition, phase: CompetitionPhase.groupe);
    ParticipationProvider participationCollection =
        await context.read<ParticipationProvider>()
          ..getParticipations();
    participations = participationCollection.phaseGroupe;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData(context),
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
        if (groupes.isEmpty || participations.isEmpty) {
          return const Center(
            child: Text('Pas de données!'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              for (Groupe groupe in groupes)
                Builder(builder: (context) {
                  final List<Participation> parts = participations
                      .where((element) => element.idGroupe == groupe.idGroupe)
                      .toList();
                  return Column(
                    children: [
                      Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 1),
                          child: SectionTitleWidget(
                              title: 'Groupe ${groupe.nomGroupe}')),
                      for (Participation part in parts)
                        Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 1),
                          child: EquipeListTileWidget(
                            border: false,
                            title: (part.participant.nomEquipe),
                            id: part.idParticipant.toString(),
                          ),
                        ),
                      const SizedBox(height: 10.0),
                    ],
                  );
                })
            ],
          ),
        );
      },
    );
  }
}

class ParticipantWidget extends StatelessWidget {
  final Competition competition;
  const ParticipantWidget({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context
            .read<ParticipantProvider>()
            .getParticipantByEdition(competition.codeEdition),
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

          final List<Participant> participants = snapshot.data!;
          if (participants.isEmpty) {
            return const Center(
              child: Text('Pas d\'équipe!'),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                for (Participant participant in participants)
                  Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    child: EquipeListTileWidget(
                        id: participant.idParticipant,
                        title: participant.nomEquipe),
                  )
              ],
            ),
          );
        });
  }
}
