import 'package:app/models/infos/infos.dart';
import 'package:app/providers/infos_provider.dart';
import 'package:app/widget/infos_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfosListWiget extends StatelessWidget {
  final String? idPartcipant;
  final String? idPartcipant2;
  final String? idJoueur;
  final String? idEdition;
  final String? idGame;
  const InfosListWiget(
      {super.key,
      this.idPartcipant,
      this.idPartcipant2,
      this.idEdition,
      this.idGame,
      this.idJoueur});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.read<InfosProvider>().getInformations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('erreur!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<InfosProvider>(builder: (context, value, child) {
            final List<Infos> liste = value.getInfosBy(
              idEdition: idEdition,
              idGame: idGame,
              idJoueur: idJoueur,
              idPartcipant: idPartcipant,
              idPartcipant2: idPartcipant2,
            );

            return liste.isEmpty
                ? const Center(
                    child: Text(
                        'Pas d\'information disponible pour cette element!'),
                  )
                : ListView.separated(
                    itemCount: liste.length,
                    separatorBuilder: (context, index) => const SizedBox(),
                    itemBuilder: (context, index) => InfosWidget(
                      infos: liste[index],
                    ),
                  );
          });
        });
  }
}
