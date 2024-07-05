import 'package:app/models/stat.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/service/stat_service.dart';
import 'package:app/widget/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassementWiget extends StatelessWidget {
  final String title;
  final String? idGroupe;
  final String? idParticipant;
  final List<String>? targets;
  const ClassementWiget(
      {super.key,
      required this.title,
      this.idGroupe,
      this.idParticipant,
      this.targets});
  factory ClassementWiget.equipe(
          {required String title,
          required String idParticipant,
          required String idTarget}) =>
      ClassementWiget(
        title: title,
        idParticipant: idParticipant,
        targets: [idTarget],
      );

  Future<List<Stat>> _getStat(BuildContext context) async {
    List<Stat> stats = [];
    if (idGroupe != null) {
      stats = await StatService(context: context)
          .getStatByGroupe(idGroupe: idGroupe!);
    } else if (idParticipant != null) {
      stats = await StatService(context: context)
          .getStatByEquipe(idParticipant: idParticipant!);
    }
    return stats;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, val, child) {
      return FutureBuilder(
          future: _getStat(context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Erreur!'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final List<Stat> stat = snapshot.data!;
            int selected = 0;
            return StatefulBuilder(builder: (context, setState) {
              final List<bool> isSelected = [false, false];
              isSelected[selected] = true;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
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
                    ),
                    Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      color: Colors.white,
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Column(
                          children: [
                            Text(
                              '$title',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            TableWidget(
                              targets: targets,
                              stats: stat,
                              expand: selected == 0,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
          });
    });
  }
}
