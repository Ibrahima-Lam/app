import 'package:fscore/models/stat.dart';
import 'package:fscore/providers/game_provider.dart';
import 'package:fscore/service/stat_service.dart';
import 'package:fscore/widget/app/section_title_widget.dart';
import 'package:fscore/widget/classement/classement_toggle_botton_widget.dart';
import 'package:fscore/widget/classement/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassementListWidget extends StatelessWidget {
  final String codeEdition;
  const ClassementListWidget({super.key, required this.codeEdition});

  Future<Map<String, List<Stat>>> _getStat(BuildContext context) async {
    return await StatService(
      context: context,
      codeEdition: codeEdition,
    ).getStatByEdition(codeEdition: codeEdition);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, value, child) {
      return FutureBuilder<Map<String, List<Stat>>>(
        future: _getStat(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final Map<String, List<Stat>> statistiques = snapshot.data ?? {};
          if (statistiques.isEmpty) {
            return const Center(
              child: Text('Pas de Données!'),
            );
          }
          int selected = 0;
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
                child: Column(children: [
              ClassementToggleBottonWidget(
                  onSelected: (index) {
                    setState(() => selected = index);
                  },
                  selected: selected),
              for (var stat in statistiques.entries)
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  color: Colors.white,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SectionTitleWidget(title: 'Groupe ${stat.key}'),
                        TableWidget(
                          stats: stat.value,
                          expand: selected == 0,
                        )
                      ],
                    ),
                  ),
                ),
            ]));
          });
        },
      );
    });
  }
}
