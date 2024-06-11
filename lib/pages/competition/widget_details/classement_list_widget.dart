import 'package:app/models/stat.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/service/stat_service.dart';
import 'package:app/widget/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassementListWidget extends StatelessWidget {
  final String codeEdition;
  const ClassementListWidget({super.key, required this.codeEdition});

  Future<Map<String, List<Stat>>> _getStat(BuildContext context) async {
    return await StatService(context: context)
        .getStatByEdition(codeEdition: codeEdition);
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
            return const Center(
              child: Text('Erreur!'),
            );
          }
          final Map<String, List<Stat>> statistiques = snapshot.data!;
          if (statistiques.isEmpty) {
            return const Center(
              child: Text('Pas de Données!'),
            );
          }
          int selected = 0;
          return StatefulBuilder(builder: (context, setState) {
            final List<bool> isSelected = [false, false];
            isSelected[selected] = true;
            List<Widget> statsWidgets = [
              Container(
                color: Colors.white,
                child: ToggleButtons(
                  fillColor: Theme.of(context).primaryColor,
                  color: Theme.of(context).primaryColor,
                  selectedColor: Colors.white,
                  onPressed: (index) {
                    setState(
                      () {
                        selected = index;
                      },
                    );
                  },
                  children: [
                    Text('Tous'),
                    Text('Moins'),
                  ],
                  isSelected: isSelected,
                ),
              )
            ];
            statistiques.forEach((key, value) {
              statsWidgets.add(Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Text(
                        'Groupe $key',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TableWidget(
                        stats: value,
                        expand: selected == 0,
                      )
                    ],
                  ),
                ),
              ));
            });
            return ListView(children: statsWidgets);
          });
        },
      );
    });
  }
}
