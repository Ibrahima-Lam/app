import 'package:app/models/arbitres/arbitre.dart';
import 'package:app/providers/arbitre_provider.dart';
import 'package:app/widget/arbitre/arbitre_list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomModalArbitreListWidget extends StatelessWidget {
  final String idEdition;
  const BottomModalArbitreListWidget({super.key, required this.idEdition});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<ArbitreProvider>().getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur de chargement!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Consumer<ArbitreProvider>(
              builder: (context, arbitreProvider, child) {
            List<Arbitre> arbitres = snapshot.data ?? [];
            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.8,
              builder: (context, scrollController) {
                return arbitres.isEmpty
                    ? Center(
                        child: Text('Pas d\'arbitre disponible cette équipe !'),
                      )
                    : Container(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: arbitres.length,
                          itemBuilder: (context, index) {
                            Arbitre arbitre = arbitres[index];
                            return ArbitreListTileWidget(
                              arbitre: arbitre,
                              onTap: (a) => Navigator.pop(context, arbitre),
                            );
                          },
                        ),
                      );
              },
            );
          });
        });
  }
}
