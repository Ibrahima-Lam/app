import 'package:app/models/sponsor.dart';
import 'package:app/pages/forms/sponsor_form.dart';
import 'package:app/providers/sponsor_provider.dart';
import 'package:app/widget/modals/confirm_dialog_widget.dart';
import 'package:app/widget/sponsor/sponsor_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class SponsorPage extends StatelessWidget {
  const SponsorPage({super.key});

  _delete(BuildContext context, Sponsor sponsor) async {
    final bool? confirm = await showDialog(
        context: context,
        builder: (context) => ConfirmDialogWidget(
            content: 'Voulez-vous supprimer ce sponsor ?', title: 'Supprimer'));
    if (confirm ?? false) {
      context.read<SponsorProvider>().deleteSponsor(sponsor.idSponsor);
    }
  }

  _edit(BuildContext context, Sponsor sponsor) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SponsorForm(sponsor: sponsor)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Les Sponsors'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: context.read<SponsorProvider>().getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('erreur!'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return Consumer<SponsorProvider>(
                  builder: (context, sponsorProvider, child) {
                List<Sponsor> sponsors = sponsorProvider.sponsors;

                return Column(
                  children: [
                    ...sponsors.map((e) => SponsorTileWidget(
                          sponsor: e,
                          onDelete: (e) => _delete(context, e),
                          onEdit: (e) => _edit(context, e),
                          enable: true,
                        ))
                  ],
                );
              });
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SponsorForm(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class SponsorTileWidget extends StatelessWidget {
  final Sponsor sponsor;
  final bool enable;
  final Function(Sponsor) onDelete;
  final Function(Sponsor) onEdit;
  const SponsorTileWidget(
      {super.key,
      required this.sponsor,
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
                onPressed: (context) => onDelete(sponsor),
                icon: Icons.delete,
                foregroundColor: Colors.red)
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
                onPressed: (context) => onEdit(sponsor),
                icon: Icons.edit,
                foregroundColor: Colors.blue)
          ],
        ),
        child: SponsorWidget(sponsor: sponsor));
  }
}
