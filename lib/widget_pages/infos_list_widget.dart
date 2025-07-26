import 'package:fscore/core/params/categorie/categorie_params.dart';
import 'package:fscore/models/infos/infos.dart';
import 'package:fscore/pages/forms/infos_form.dart';
import 'package:fscore/providers/infos_provider.dart';
import 'package:fscore/providers/paramettre_provider.dart';
import 'package:fscore/widget/infos/infos_widget.dart';
import 'package:fscore/widget/modals/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class InfosListWiget extends StatelessWidget {
  final CategorieParams? categorieParams;
  const InfosListWiget({super.key, this.categorieParams});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<InfosProvider>().getInformations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('erreur!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer2<InfosProvider, ParamettreProvider>(
              builder: (context, infosProvider, paramettreProvider, child) {
            bool checkUser =
                paramettreProvider.checkUser(categorieParams?.idEdition ?? '');
            final List<Infos> liste =
                infosProvider.getInfosBy(categorie: categorieParams);
            return liste.isEmpty && !checkUser
                ? const Center(
                    child: Text(
                        'Pas d\'information disponible pour cette element!'),
                  )
                : InfosListSectionWidget(
                    liste: liste,
                    enable: checkUser,
                    categorieParams: categorieParams);
          });
        });
  }
}

class InfosListSectionWidget extends StatefulWidget {
  final List<Infos> liste;
  final bool enable;
  final CategorieParams? categorieParams;
  const InfosListSectionWidget(
      {super.key,
      required this.liste,
      required this.enable,
      this.categorieParams});

  @override
  State<InfosListSectionWidget> createState() => _InfosListSectionWidgetState();
}

class _InfosListSectionWidgetState extends State<InfosListSectionWidget> {
  void _onDelete(Infos infos) async {
    final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => ConfirmDialogWidget(
              title: 'Supprimer',
              content: 'Voulez-vous supprimer cette information?',
            ));
    if (confirm ?? false) {
      context.read<InfosProvider>().deleteInfos(infos.idInfos);
    }
  }

  void _onEdit(Infos infos) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InfosForm(
                infos: infos,
                categorieParams: widget.categorieParams ?? CategorieParams())));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        ...widget.liste
            .map(
              (e) => InfosTileWidget(
                  enable: widget.enable,
                  infos: e,
                  onDelete: (inf) => setState(() {
                        _onDelete(inf);
                      }),
                  onEdit: (inf) => setState(() {
                        _onEdit(inf);
                      })),
            )
            .toList(),
        if (widget.enable && widget.categorieParams != null)
          OutlinedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InfosForm(
                              categorieParams: widget.categorieParams!,
                            )));
              },
              child: const Text('Ajouter une information')),
      ],
    ));
  }
}

class InfosTileWidget extends StatelessWidget {
  final Infos infos;
  final bool enable;
  final Function(Infos) onDelete;
  final Function(Infos) onEdit;
  const InfosTileWidget(
      {super.key,
      required this.infos,
      required this.enable,
      required this.onDelete,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Slidable(
        enabled: enable,
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
                onPressed: (context) => onDelete(infos),
                icon: Icons.delete,
                foregroundColor: Colors.red)
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
                onPressed: (context) => onEdit(infos),
                icon: Icons.edit,
                foregroundColor: Colors.blue)
          ],
        ),
        child: InfosWidget(infos: infos));
  }
}
