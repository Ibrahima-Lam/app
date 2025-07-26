import 'package:fscore/models/participant.dart';
import 'package:fscore/pages/forms/participant_form.dart';
import 'package:fscore/providers/participant_provider.dart';
import 'package:fscore/widget/logos/equipe_logo_widget.dart';
import 'package:fscore/widget/modals/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class CompetitionParticipantWidget extends StatefulWidget {
  final String codeEdition;
  const CompetitionParticipantWidget({super.key, required this.codeEdition});

  @override
  State<CompetitionParticipantWidget> createState() =>
      _CompetitionParticipantWidgetState();
}

class _CompetitionParticipantWidgetState
    extends State<CompetitionParticipantWidget> {
  _onDelete(Participant participant) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
            title: 'Suppression',
            content: 'Voulez vous supprimer cet element ?');
      },
    );
    if (confirm == true)
      await context
          .read<ParticipantProvider>()
          .removeParticipant(participant.idParticipant);
  }

  _onEdit(Participant participant) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ParticipantForm(
              participant: participant,
              codeEdition: participant.codeEdition,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ParticipantProvider>(
      builder: (context, participantProvider, child) {
        List<Participant> participants = participantProvider.participants
            .where((element) => element.codeEdition == widget.codeEdition)
            .toList();
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 5.0),
              ...participants
                  .map((e) => ParticipantTileWidget(
                      participant: e, onDelete: _onDelete, onEdit: _onEdit))
                  .toList(),
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ParticipantForm(codeEdition: widget.codeEdition)));
                  },
                  child: Text('Ajouter')),
            ],
          ),
        );
      },
    );
  }
}

class ParticipantTileWidget extends StatelessWidget {
  final Participant participant;
  final Function(Participant participant) onDelete;
  final Function(Participant participant) onEdit;
  const ParticipantTileWidget(
      {super.key,
      required this.participant,
      required this.onDelete,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
      child: Slidable(
        startActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: (context) => onDelete(participant),
              icon: Icons.delete,
              foregroundColor: Colors.red,
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: (context) => onEdit(participant),
              icon: Icons.edit,
              foregroundColor: Colors.grey,
            ),
          ],
        ),
        child: ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: EquipeImageLogoWidget(
                url: participant.imageUrl,
              ),
            ),
            title: Text(participant.nomEquipe),
            subtitle: Text(participant.libelleEquipe ?? '')),
      ),
    );
  }
}
