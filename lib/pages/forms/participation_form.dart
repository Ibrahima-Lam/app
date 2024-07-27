import 'package:app/core/extension/list_extension.dart';
import 'package:app/core/extension/string_extension.dart';
import 'package:app/models/groupe.dart';
import 'package:app/models/participant.dart';
import 'package:app/models/participation.dart';
import 'package:app/providers/groupe_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/providers/participation_provider.dart';
import 'package:app/widget/form/elevated_button_form_widget.dart';
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
        idParticipation: widget.codeEdition + participantController.text,
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
    return Scaffold(
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

            return Consumer2<ParticipantProvider, GroupeProvider>(
                builder: (context, participantProvider, groupeProvider, _) {
              final List<Groupe> groupes = groupeProvider.groupes
                  .where((element) => element.codeEdition == widget.codeEdition)
                  .toList();
              final List<Participant> participants = participantProvider
                  .participants
                  .where((element) => element.codeEdition == widget.codeEdition)
                  .toList();
              final Map<String, dynamic> groupeMap = groupes.asMap().map(
                  (key, value) => MapEntry(value.nomGroupe, value.idGroupe));
              final Map<String, dynamic> participantMap = participants
                  .asMap()
                  .map((key, value) =>
                      MapEntry(value.nomEquipe, value.idParticipant));

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    DropDownButtonWidget(
                      controller: participantController,
                      entries: participantMap,
                      label: 'Equipe',
                    ),
                    DropDownButtonWidget(
                      controller: groupeController,
                      entries: groupeMap,
                      label: 'Groupe',
                    ),
                    ElevatedButtonFormWidget(
                      onPressed: () => _onSubmit(context),
                      isSending: isLoading,
                    ),
                  ],
                ),
              );
            });
          }),
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
        width: MediaQuery.sizeOf(context).width * .98,
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
