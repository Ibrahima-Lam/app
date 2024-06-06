import 'package:app/models/game.dart';
import 'package:app/models/statistique.dart';
import 'package:app/providers/statistique_provider.dart';
import 'package:app/widget/stat_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatistiqueWidget extends StatelessWidget {
  final Game game;
  const StatistiqueWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatistiqueProvider>(
      builder: (context, value, child) {
        List<Statistique> statistiques = value.getGameStatistiques(game);

        return Card(
          child: ListView(
            children: [
              ...statistiques.map((e) => StatWidget(
                    statistique: e,
                    one: ['possession'].contains(e.codeStatistique),
                  ))
            ],
          ),
        );
      },
    );
  }
}
