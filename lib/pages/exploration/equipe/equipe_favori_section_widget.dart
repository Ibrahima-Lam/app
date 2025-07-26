import 'package:fscore/models/competition.dart';
import 'package:fscore/models/participant.dart';
import 'package:fscore/pages/exploration/equipe/equipe_tile_widget.dart';
import 'package:fscore/providers/favori_provider.dart';
import 'package:fscore/providers/participant_provider.dart';
import 'package:fscore/widget/app/favori_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EquipeFavoriSectionWidget extends StatelessWidget {
  final ParticipantProvider participantProvider;
  final Competition competition;
  final Function(Participant participant) onExplore;
  const EquipeFavoriSectionWidget(
      {super.key,
      required this.participantProvider,
      required this.competition,
      required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriProvider>(
      builder: (context, favoriProvider, child) {
        List<Participant> participants = participantProvider.participants
            .where((element) =>
                element.codeEdition == competition.codeEdition &&
                favoriProvider.equipes.any(
                  (e) => e == element.idParticipant,
                ))
            .toList();
        return participants.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    FavoriTitleWidget(
                      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                    ),
                    EquipeHorizontalListWidget(
                        participants: participants, onExplore: onExplore),
                  ],
                ),
              );
      },
    );
  }
}

class EquipeHorizontalListWidget extends StatelessWidget {
  final List<Participant> participants;
  final Function(Participant participant) onExplore;
  const EquipeHorizontalListWidget(
      {super.key, required this.participants, required this.onExplore});

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
            children: participants
                .map((e) => EquipeVerticalTileWidget(
                      onExplore: onExplore,
                      participant: e,
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
