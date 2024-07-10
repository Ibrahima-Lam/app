import 'package:app/models/arbitres/arbitre.dart';
import 'package:app/providers/arbitre_provider.dart';
import 'package:app/widget/arbitre_list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArbitreListWidget extends StatelessWidget {
  final String idEdition;
  const ArbitreListWidget({super.key, required this.idEdition});

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
                .where((element) => element.idEdition == idEdition)
                .toList();
            return arbitres.isEmpty
                ? const Center(
                    child: Text(
                        'Pas d\'arbitre disponible pour cette competition'),
                  )
                : SingleChildScrollView(
                    child: Card(
                      child: Column(
                        children: arbitres
                            .map((e) => ArbitreListTileWidget(arbitre: e))
                            .toList(),
                      ),
                    ),
                  );
          });
        });
  }
}
