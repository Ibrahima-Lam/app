import 'package:fscore/core/extension/list_extension.dart';
import 'package:fscore/core/extension/string_extension.dart';
import 'package:fscore/models/groupe.dart';
import 'package:fscore/models/participant.dart';
import 'package:fscore/models/participation.dart';
import 'package:fscore/providers/groupe_provider.dart';
import 'package:fscore/providers/participant_provider.dart';
import 'package:fscore/providers/participation_provider.dart';
import 'package:fscore/widget/form/elevated_button_form_widget.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParticipationForm extends StatefulWidget {
  final String codeEdition;
  final Participation? participation;
  const ParticipationForm(
      {super.key, required this.codeEdition, this.participation});

  @override
  State<ParticipationForm> createState() => _ParticipationFormState();
}

class _ParticipationFormState extends State<ParticipationForm> {
  late final TextEditingController participantController;
  late final TextEditingController groupeController;

  @override
  void initState() {
    participantController =
        TextEditingController(text: widget.participation?.idParticipant);
    groupeController =
        TextEditingController(text: widget.participation?.idGroupe);
    super.initState();
  }

  bool isLoading = false;
  void setIsloading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  void _onSubmit(BuildContext context) async {
    if (participantController.text.isEmpty || groupeController.text.isEmpty)
      return;
    final Participant? participant =
        context.read<ParticipantProvider>().participants.singleWhereOrNull(
              (element) =>
                  element.codeEdition == widget.codeEdition &&
                  element.idParticipant == participantController.text,
            );
    final Groupe? groupe =
        context.read<GroupeProvider>().groupes.singleWhereOrNull(
              (element) =>
                  element.codeEdition == widget.codeEdition &&
                  element.idGroupe == groupeController.text,
            );
    if (participant == null || groupe == null) return;
    final Participation participation = Participation(
        idParticipation: widget.participation?.idParticipation ??
            widget.codeEdition + groupe.nomGroupe + participantController.text,
        idParticipant: participantController.text,
        idGroupe: groupeController.text,
        groupe: groupe,
        participant: participant);
    setIsloading(true);
    final bool res = widget.participation != null
        ? await context.read<ParticipationProvider>().editParticipation(
            widget.participation!.idParticipation, participation)
        : await context
            .read<ParticipationProvider>()
            .addParticipation(participation);
    setIsloading(false);
    if (res) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Formulaire de  Participations'),
        ),
        body: FutureBuilder(
            future: Future.wait([
              context.read<ParticipantProvider>().getParticipants(),
              context.read<GroupeProvider>().getGroupes(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('erreur!'),
                );
              }

              return Consumer3<ParticipantProvider, GroupeProvider,
                      ParticipationProvider>(
                  builder: (context, participantProvider, groupeProvider,
                      participationProvider, _) {
                final List<Groupe> groupes = groupeProvider.groupes
                    .where(
                        (element) => element.codeEdition == widget.codeEdition)
                    .toList();
                final List<Participant> participants = participantProvider
                    .participants
                    .where(
                        (element) => element.codeEdition == widget.codeEdition)
                    .toList();
                final Map<String, dynamic> groupeMap = groupes.asMap().map(
                    (key, value) => MapEntry(value.nomGroupe, value.idGroupe));

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      DropDownButtonWidget(
                        controller: groupeController,
                        entries: groupeMap,
                        label: 'Groupe',
                      ),
                      ListenableBuilder(
                          listenable: groupeController,
                          builder: (context, _) {
                            final Map<String, dynamic> participantMap =
                                participants
                                    .where((element) {
                                      if (groupeController.text.isEmpty)
                                        return true;
                                      return !participationProvider
                                          .participations
                                          .any((e) =>
                                              e.idGroupe ==
                                                  groupeController.text &&
                                              e.idParticipant ==
                                                  element.idParticipant);
                                    })
                                    .toList()
                                    .asMap()
                                    .map((key, value) => MapEntry(
                                        value.nomEquipe, value.idParticipant));
                            return DropDownButtonWidget(
                              controller: participantController,
                              entries: participantMap,
                              label: 'Equipe',
                            );
                          }),
                      ElevatedButtonFormWidget(
                        onPressed: () => _onSubmit(context),
                        isSending: isLoading,
                      ),
                    ],
                  ),
                );
              });
            }),
      ),
    );
  }
}

class DropDownButtonWidget extends StatelessWidget {
  final Map<String, dynamic> entries;
  final String label;
  final TextEditingController controller;
  const DropDownButtonWidget(
      {super.key,
      required this.entries,
      required this.label,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DropdownMenu(
        initialSelection: controller.text.isNotEmpty ? controller.text : null,
        onSelected: (value) {
          if (value != null) controller.text = value.toString();
        },
        menuStyle: MenuStyle(
            shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(side: BorderSide.none)),
            backgroundColor: WidgetStatePropertyAll(Colors.white)),
        width: MediaQuery.of(context).size.width * .98,
        label: Text(label, style: Theme.of(context).textTheme.titleMedium),
        dropdownMenuEntries: [
          ...entries.entries.map(
            (e) {
              return DropdownMenuEntry(
                  label: e.key,
                  value: e.value.toString(),
                  labelWidget: Text(e.key.capitalize()));
            },
          ).toList(),
        ],
      ),
    );
  }
}
