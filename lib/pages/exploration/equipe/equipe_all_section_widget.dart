import 'package:app/models/competition.dart';
import 'package:app/models/participant.dart';
import 'package:app/pages/exploration/equipe/equipe_tile_widget.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/widget/app/favori_title_widget.dart';
import 'package:flutter/material.dart';

class EquipeAllSectionWidget extends StatelessWidget {
  final ParticipantProvider participantProvider;
  final TextEditingController controller;
  final Competition competition;
  final Function(Participant participant) onExplore;
  const EquipeAllSectionWidget({
    super.key,
    required this.participantProvider,
    required this.controller,
    required this.onExplore,
    required this.competition,
  });

  @override
  Widget build(BuildContext context) {
    List<Participant> participants = participantProvider.participants
        .where((element) => element.codeEdition == competition.codeEdition)
        .toList()
      ..sort((a, b) => ((b.rating ?? 0) - (a.rating ?? 0)).toInt());
    if (controller.text.isNotEmpty) {
      participants = participants
          .where((element) => element.nomEquipe
              .toUpperCase()
              .contains(controller.text.toUpperCase()))
          .toList();
    }
    return participants.isEmpty
        ? Container(
            height: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(controller.text.isEmpty
                  ? 'Pas d\'équipe disponible!'
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
                      children: participants
                          .map((e) => EquipeHorizontalTileWidget(
                                participant: e,
                                onExplore: onExplore,
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
