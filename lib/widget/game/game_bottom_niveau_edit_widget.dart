import 'package:fscore/models/niveau.dart';
import 'package:fscore/service/niveau_service.dart';
import 'package:fscore/widget/app/section_title_widget.dart';
import 'package:flutter/material.dart';

class GameBottomNiveauEditWidget extends StatelessWidget {
  const GameBottomNiveauEditWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: NiveauService.getNiveaux(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('erreur!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          List<Niveau> niveaux = snapshot.data ?? [];

          return DraggableScrollableSheet(
              minChildSize: 0.9,
              initialChildSize: 1,
              builder: (context, scrollController) => ListView(
                    controller: scrollController,
                    children: [
                      Center(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text('Supprimer')),
                      ),
                      SectionTitleWidget(title: 'Liste de Niveau'),
                      ...niveaux
                          .map((e) => ListTile(
                                onTap: () {
                                  Navigator.pop(context, e);
                                },
                                leading: Icon(
                                    Icons.settings_backup_restore_outlined),
                                title: Text(e.nomNiveau),
                                subtitle: Text(e.typeNiveau),
                              ))
                          .toList()
                    ],
                  ));
        });
  }
}
