import 'package:app/models/stat.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/service/stat_service.dart';
import 'package:app/widget/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassementWiget extends StatelessWidget {
  final String title;
  final String idGroupe;
  const ClassementWiget(
      {super.key, required this.title, required this.idGroupe});

  Future<List<Stat>> _getStat(BuildContext context, String idGroupe) async {
    return await StatService(context: context)
        .getStatByGroupe(idGroupe: idGroupe);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, val, child) {
      return FutureBuilder(
          future: _getStat(context, idGroupe),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('erreur!'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              );
            }

            final List<Stat> stat = snapshot.data!;
            int selected = 0;
            return StatefulBuilder(builder: (context, setState) {
              final List<bool> isSelected = [false, false];
              isSelected[selected] = true;
              return ListView(
                children: [
                  Container(
                    color: Colors.white,
                    child: ToggleButtons(
                      fillColor: Colors.green,
                      color: Colors.green,
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
                  ),
                  Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text(
                          '$title',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        TableWidget(
                          stats: stat,
                          expand: selected == 0,
                        )
                      ],
                    ),
                  ),
                ],
              );
            });
          });
    });
  }
}
