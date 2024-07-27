import 'package:app/models/groupe.dart';
import 'package:app/pages/forms/groupe_form.dart';
import 'package:app/providers/groupe_provider.dart';
import 'package:app/widget/modals/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class CompetitionGroupeListWidget extends StatefulWidget {
  final String codeEdition;
  const CompetitionGroupeListWidget({super.key, required this.codeEdition});

  @override
  State<CompetitionGroupeListWidget> createState() =>
      _CompetitionGroupeListWidgetState();
}

class _CompetitionGroupeListWidgetState
    extends State<CompetitionGroupeListWidget> {
  _onDelete(Groupe groupe) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
            title: 'Suppression',
            content: 'Voulez vous supprimer cet element ?');
      },
    );
    if (confirm == true)
      await context.read<GroupeProvider>().removeGroupe(groupe.idGroupe);
  }

  _onEdit(Groupe groupe) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GroupeForm(
              groupe: groupe,
              codeEdition: groupe.codeEdition,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<GroupeProvider>().getGroupes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('erreur!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<GroupeProvider>(
              builder: (context, groupeProvider, _) {
            List<Groupe> groupes = groupeProvider.groupes
                .where((element) => element.codeEdition == widget.codeEdition)
                .toList();

            return groupes.isEmpty
                ? const Center(
                    child: Text('Pas de groupe disponible pour cette edition'),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 5.0),
                        ...groupes
                            .map((e) => GroupeTileWidget(
                                onDelete: _onDelete,
                                onEdit: _onEdit,
                                groupe: e))
                            .toList(),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => GroupeForm(
                                      codeEdition: widget.codeEdition)));
                            },
                            child: Text('Ajouter'))
                      ],
                    ),
                  );
          });
        });
  }
}

class GroupeTileWidget extends StatelessWidget {
  final Groupe groupe;
  final Function(Groupe groupe) onDelete;
  final Function(Groupe groupe) onEdit;
  const GroupeTileWidget(
      {super.key,
      required this.groupe,
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
              onPressed: (context) => onDelete(groupe),
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
              onPressed: (context) => onEdit(groupe),
              icon: Icons.edit,
              foregroundColor: Colors.grey,
            ),
          ],
        ),
        child: ListTile(
            title: Text(groupe.nomGroupe),
            subtitle: Text(groupe.phase.nomPhase)),
      ),
    );
  }
}
