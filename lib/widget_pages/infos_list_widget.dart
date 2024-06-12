import 'package:app/models/infos.dart';
import 'package:app/providers/infos_provider.dart';
import 'package:app/widget/infos_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfosListWiget extends StatelessWidget {
  const InfosListWiget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<InfosProvider>().getInformations(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Erreur'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Consumer<InfosProvider>(builder: (context, value, child) {
          final List<Infos> liste = value.infos;
          return ListView.separated(
            itemCount: liste.length,
            separatorBuilder: (context, index) => const SizedBox(),
            itemBuilder: (context, index) => InfosWidget(
              infos: liste[index],
            ),
          );
        });
      },
    );
  }
}
