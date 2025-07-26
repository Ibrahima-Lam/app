import 'package:fscore/models/coachs/coach.dart';

import 'package:fscore/providers/coach_provider.dart';
import 'package:fscore/widget/coach/coach_list_tile_widget.dart';
import 'package:fscore/widget/form/text_search_field_widget.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoachPage extends StatelessWidget {
  CoachPage({super.key});

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Entraineurs'),
        ),
        body: Container(
          child: FutureBuilder(
            future: context.read<CoachProvider>().getData(),
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
              return Consumer<CoachProvider>(builder: (context, value, child) {
                List<Coach> coachs = value.coachs;
                return coachs.length == 0
                    ? const Center(
                        child: Text('Pas de données!'),
                      )
                    : Column(
                        children: [
                          TextSearchFieldWidget(
                              textEditingController: textEditingController,
                              hintText: 'Recherche d\'coach...'),
                          Expanded(
                              child: Card(
                            child: ListenableBuilder(
                                listenable: textEditingController,
                                builder: (context, child) {
                                  coachs = textEditingController.text.isNotEmpty
                                      ? coachs
                                          .where((element) => element.nomCoach
                                              .toUpperCase()
                                              .contains(textEditingController
                                                  .text
                                                  .toUpperCase()))
                                          .toList()
                                      : value.coachs;

                                  return Scrollbar(
                                    child: ListView.builder(
                                      itemCount: coachs.length,
                                      itemBuilder: (context, index) =>
                                          CoachListTileWidget(
                                        coach: coachs[index],
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
      ),
    );
  }
}
