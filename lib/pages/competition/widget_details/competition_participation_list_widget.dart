import 'package:app/models/participation.dart';
import 'package:app/pages/forms/participation_form.dart';
import 'package:app/providers/participation_provider.dart';
import 'package:app/widget/modals/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class CompetitionParticipationListWidget extends StatefulWidget {
  final String codeEdition;
  const CompetitionParticipationListWidget(
      {super.key, required this.codeEdition});

  @override
  State<CompetitionParticipationListWidget> createState() =>
      _CompetitionParticipationListWidgetState();
}

class _CompetitionParticipationListWidgetState
    extends State<CompetitionParticipationListWidget> {
  _onDelete(Participation groupe) async {
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
          .read<ParticipationProvider>()
          .removeParticipation(groupe.idParticipation);
  }

  _onEdit(Participation participation) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ParticipationForm(
              participation: participation,
              codeEdition: widget.codeEdition,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<ParticipationProvider>().getParticipations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<ParticipationProvider>(
              builder: (context, participationProvider, _) {
            List<Participation> participations = participationProvider
                .participations
                .where((element) =>
                    element.groupe.codeEdition == widget.codeEdition)
                .toList();

            return participations.isEmpty
                ? const Center(
                    child: Text(
                        'Pas de participation disponible pour cette edition'),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 5.0),
                        ...participations
                            .map((e) => ParticipationTileWidget(
                                onDelete: _onDelete,
                                onEdit: _onEdit,
                                participation: e))
                            .toList(),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ParticipationForm(
                                      codeEdition: widget.codeEdition)));
                            },
                            child: Text('Ajouter')),
                      ],
                    ),
                  );
          });
        });
  }
}

class ParticipationTileWidget extends StatelessWidget {
  final Participation participation;
  final Function(Participation participation) onDelete;
  final Function(Participation participation) onEdit;
  const ParticipationTileWidget(
      {super.key,
      required this.participation,
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
              onPressed: (context) => onDelete(participation),
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
              onPressed: (context) => onEdit(participation),
              icon: Icons.edit,
              foregroundColor: Colors.grey,
            ),
          ],
        ),
        child: ListTile(
            title: Text(participation.participant.nomEquipe),
            subtitle: Text(participation.groupe.nomGroupe)),
      ),
    );
  }
}
