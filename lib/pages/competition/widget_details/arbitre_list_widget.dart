import 'package:app/models/arbitres/arbitre.dart';
import 'package:app/pages/forms/arbitre_form.dart';
import 'package:app/providers/arbitre_provider.dart';
import 'package:app/widget/arbitre/arbitre_list_tile_widget.dart';
import 'package:app/widget/modals/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ArbitreListWidget extends StatefulWidget {
  final String idEdition;
  final bool checkUser;
  const ArbitreListWidget(
      {super.key, required this.idEdition, required this.checkUser});

  @override
  State<ArbitreListWidget> createState() => _ArbitreListWidgetState();
}

class _ArbitreListWidgetState extends State<ArbitreListWidget> {
  _onDelete(Arbitre arbitre) async {
    final bool confirm = await showDialog(
        context: context,
        builder: (context) => const ConfirmDialogWidget(
              title: 'Supprimer',
              content: 'Voulez vous supprimer cet arbitre ?',
            ));
    if (confirm) {
      context.read<ArbitreProvider>().deleteArbitre(arbitre.idArbitre);
    }
  }

  _onEdit(Arbitre arbitre) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ArbitreForm(arbitre: arbitre, idEdition: widget.idEdition)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<ArbitreProvider>().getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<ArbitreProvider>(builder: (context, val, child) {
            final List<Arbitre> arbitres = val.arbitres
                .where((element) => element.idEdition == widget.idEdition)
                .toList();
            return arbitres.isEmpty && !widget.checkUser
                ? const Center(
                    child: Text(
                        'Pas d\'arbitre disponible pour cette competition'),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        ...arbitres
                            .map((e) => Card(
                                elevation: 2,
                                margin: EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 4),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0)),
                                shadowColor: Colors.grey,
                                child: ArbitreTileWidget(
                                    arbitre: e,
                                    checkUser: widget.checkUser,
                                    onDelete: _onDelete,
                                    onEdit: _onEdit)))
                            .toList(),
                        if (widget.checkUser)
                          OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ArbitreForm(
                                        idEdition: widget.idEdition)));
                              },
                              child: Text('Ajouter'))
                      ],
                    ),
                  );
          });
        });
  }
}

class ArbitreTileWidget extends StatelessWidget {
  final Arbitre arbitre;
  final bool checkUser;
  final Function(Arbitre) onDelete;
  final Function(Arbitre) onEdit;
  const ArbitreTileWidget(
      {super.key,
      required this.arbitre,
      required this.checkUser,
      required this.onDelete,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Slidable(
        enabled: checkUser,
        startActionPane: ActionPane(
            extentRatio: 0.2,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                  onPressed: (context) => onDelete(arbitre),
                  icon: Icons.delete,
                  foregroundColor: Colors.red)
            ]),
        endActionPane: ActionPane(
            extentRatio: 0.2,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                  onPressed: (context) => onEdit(arbitre),
                  icon: Icons.edit,
                  foregroundColor: Colors.blue)
            ]),
        child: ArbitreListTileWidget(arbitre: arbitre));
  }
}
