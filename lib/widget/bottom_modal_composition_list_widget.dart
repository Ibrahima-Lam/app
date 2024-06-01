import 'package:app/collection/composition_collection.dart';
import 'package:app/models/composition.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/widget/substitut_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomModalSheetCompositionListWidget extends StatelessWidget {
  final String idParticipant;
  final String idGame;
  const BottomModalSheetCompositionListWidget(
      {super.key, required this.idParticipant, required this.idGame});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<CompositionProvider>().getCompositions(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur de chargement!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
          final CompositionCollection compositionCollection = snapshot.data!;
          final List<JoueurComposition> titulaires =
              compositionCollection.getTitulaire(
                  idGame: idGame, idParticipant: idParticipant, create: false);
          final List<JoueurComposition> rempls = compositionCollection.getRempl(
              idGame: idGame, idParticipant: idParticipant, create: false);
          return Consumer<CompositionProvider>(builder: (context, val, child) {
            return DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                    color: Colors.white,
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          padding: const EdgeInsets.all(10.0),
                          color: Colors.grey[400],
                          height: 50,
                          child: Text(
                            'Liste de Composition ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        CompositionSectionWidget(
                            compositions: titulaires, title: "Titulaires"),
                        const SizedBox(height: 10.0),
                        CompositionSectionWidget(
                            compositions: rempls, title: "Remplaçants"),
                      ],
                    ));
              },
            );
          });
        });
  }
}

class CompositionSectionWidget extends StatelessWidget {
  final String title;
  final List<JoueurComposition> compositions;
  const CompositionSectionWidget(
      {super.key, required this.compositions, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.all(10.0),
          color: Colors.grey[200],
          height: 50,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ...compositions
            .map((e) => CompositionListTileWidget(composition: e))
            .toList(),
        if (compositions.isEmpty)
          Container(
            height: 100,
            child: Center(
                child:
                    Text('Pas de compositions disponible pour cette section!')),
          )
      ],
    );
  }
}

class CompositionListTileWidget extends StatelessWidget {
  final JoueurComposition composition;
  const CompositionListTileWidget({super.key, required this.composition});

  String? get subtitle => composition.isIn
      ? composition.entrant != null
          ? composition.entrant!.nom
          : ''
      : composition.sortant != null
          ? composition.sortant?.nom
          : '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(width: 0.5, color: Colors.grey)),
      ),
      child: ListTile(
        leading: SubstitutLogoWidget(composition: composition),
        title: Text(composition.nom),
        subtitle: Text(subtitle ?? ''),
        onTap: () => Navigator.pop(context, composition),
      ),
    );
  }
}
