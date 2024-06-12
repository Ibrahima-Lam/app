import 'package:app/collection/groupe_collection.dart';
import 'package:app/collection/participation_collection.dart';
import 'package:app/core/enums/competition_phase_enum.dart';
import 'package:app/core/enums/competition_type.dart';
import 'package:app/models/competition.dart';
import 'package:app/models/groupe.dart';
import 'package:app/models/participant.dart';
import 'package:app/models/participation.dart';
import 'package:app/providers/groupe_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/providers/participation_provider.dart';
import 'package:app/widget/equipe_widget.dart';
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
    GroupeCollection groupeCollection =
        await context.read<GroupeProvider>().getGroupes();
    groupes = groupeCollection.getGroupesBy(
        edition: competition.codeEdition, phase: CompetitionPhase.groupe);
    ParticipationCollection participationCollection =
        await context.read<ParticipationProvider>().getParticipations();
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

        return ListView(
          children: [
            for (Groupe groupe in groupes)
              Card(
                child: Builder(builder: (context) {
                  final List<Participation> parts = participations
                      .where((element) => element.idGroupe == groupe.idGroupe)
                      .toList();
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.0),
                        height: 40,
                        child: Text(
                          'Groupe ${groupe.nomGroupe}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      for (Participation part in parts)
                        EquipeListTileWidet(
                          title: (part.nomEquipe!),
                          id: part.idParticipant.toString(),
                        )
                    ],
                  );
                }),
              )
          ],
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
            .getParticipantByEdition(competition.codeEdition!),
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
          return Card(
              child: ListView.builder(
            itemCount: participants.length,
            itemBuilder: (context, index) {
              final Participant participant = participants[index];
              return EquipeListTileWidet(
                  id: participant.idParticipant, title: participant.nomEquipe);
            },
          ));
        });
  }
}
