import 'package:app/core/params/categorie/categorie_params.dart';
import 'package:app/models/infos/infos.dart';
import 'package:app/providers/infos_provider.dart';
import 'package:app/widget/infos_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfosListWiget extends StatelessWidget {
  final CategorieParams? categorieParams;
  const InfosListWiget({super.key, this.categorieParams});

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
            final List<Infos> liste = value.infos;

            return liste.isEmpty
                ? const Center(
                    child: Text(
                        'Pas d\'information disponible pour cette element!'),
                  )
                : SingleChildScrollView(
                    child: Column(
                    children: [
                      for (Infos info in liste) InfosWidget(infos: info)
                    ],
                  ));
          });
        });
  }
}
