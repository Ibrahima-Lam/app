import 'package:app/models/arbitres/arbitre.dart';

import 'package:app/providers/arbitre_provider.dart';
import 'package:app/widget/arbitre/arbitre_list_tile_widget.dart';
import 'package:app/widget/form/text_search_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArbitrePage extends StatelessWidget {
  ArbitrePage({super.key});

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arbitres'),
      ),
      body: Container(
        child: FutureBuilder(
          future: context.read<ArbitreProvider>().getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Erreur!'),
              );
            }
            return Consumer<ArbitreProvider>(builder: (context, value, child) {
              List<Arbitre> arbitres = value.arbitres;
              return arbitres.length == 0
                  ? const Center(
                      child: Text('Pas de données!'),
                    )
                  : Column(
                      children: [
                        TextSearchFieldWidget(
                            textEditingController: textEditingController,
                            hintText: 'Recherche d\'arbitre...'),
                        Expanded(
                            child: Card(
                          child: ListenableBuilder(
                              listenable: textEditingController,
                              builder: (context, child) {
                                arbitres = textEditingController.text.isNotEmpty
                                    ? arbitres
                                        .where((element) => element.nomArbitre
                                            .toUpperCase()
                                            .contains(textEditingController.text
                                                .toUpperCase()))
                                        .toList()
                                    : value.arbitres;

                                return Scrollbar(
                                  child: ListView.builder(
                                    itemCount: arbitres.length,
                                    itemBuilder: (context, index) =>
                                        ArbitreListTileWidget(
                                      arbitre: arbitres[index],
                                    ),
                                  ),
                                );
                              }),
                        ))
                      ],
                    );
            });
          },
        ),
      ),
    );
  }
}
