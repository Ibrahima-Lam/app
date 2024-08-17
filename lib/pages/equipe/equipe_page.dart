import 'package:app/models/competition.dart';
import 'package:app/models/participant.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/widget/equipe/equipe_widget.dart';
import 'package:app/widget/form/text_search_field_widget.dart';
import 'package:app/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EquipePage extends StatefulWidget {
  const EquipePage({super.key});

  @override
  State<EquipePage> createState() => _EquipePageState();
}

class _EquipePageState extends State<EquipePage> {
  late final TextEditingController textEditingController;
  ValueNotifier<String> equipeNotifier = ValueNotifier('');
  @override
  void initState() {
    textEditingController = TextEditingController()
      ..addListener(() {
        equipeNotifier.value = textEditingController.text;
      });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Equipes'),
        ),
        body: Container(
          child: FutureBuilder(
            future: context.read<ParticipantProvider>().getParticipants(),
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
              return Consumer2<ParticipantProvider, CompetitionProvider>(
                  builder: (context, participantProvider, competitionProvider,
                      child) {
                List<Participant> participants =
                    participantProvider.participants;
                Competition getCompetition(String id) =>
                    competitionProvider.collection.getElementAt(id);
                return participants.length == 0
                    ? const Center(
                        child: Text('Pas de données!'),
                      )
                    : Column(
                        children: [
                          TextSearchFieldWidget(
                              textEditingController: textEditingController,
                              hintText: 'Recherche d\'équipe...'),
                          Expanded(
                              child: Card(
                            child: ValueListenableBuilder(
                                valueListenable: equipeNotifier,
                                builder: (context, val, child) {
                                  participants = val.isNotEmpty
                                      ? participants
                                          .where((element) =>
                                              element.nomEquipe
                                                  .toUpperCase()
                                                  .startsWith(equipeNotifier
                                                      .value
                                                      .toUpperCase()) ||
                                              element.libelleEquipe!
                                                  .toUpperCase()
                                                  .startsWith(equipeNotifier
                                                      .value
                                                      .toUpperCase()))
                                          .toList()
                                      : participantProvider.participants;

                                  return Scrollbar(
                                    child: ListView.builder(
                                      itemCount: participants.length,
                                      itemBuilder: (context, index) =>
                                          EquipeListTileWidget(
                                        url: participants[index].imageUrl,
                                        id: participants[index].idParticipant,
                                        title: participants[index].nomEquipe,
                                        subtitle: getCompetition(
                                                participants[index].codeEdition)
                                            .nomCompetition,
                                      ),
                                    ),
                                  );
                                }),
                          ))
                        ],
                      );
              });
            },
          ),
        ),
      ),
    );
  }
}
