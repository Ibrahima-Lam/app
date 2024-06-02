import 'package:app/models/game.dart';
import 'package:app/providers/statistique_provider.dart';
import 'package:app/widget/stat_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatistiqueWidget extends StatefulWidget {
  final Game game;
  const StatistiqueWidget({super.key, required this.game});

  @override
  State<StatistiqueWidget> createState() => _StatistiqueWidgetState();
}

class _StatistiqueWidgetState extends State<StatistiqueWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context
          .read<StatistiqueProvider>()
          .getStatistiques(widget.game.idGame),
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

        return Consumer<StatistiqueProvider>(
          builder: (context, value, child) {
            return Card(
              child: ListView(
                children: [
                  ...value.collection.statistiques.map((e) => StatWidget(
                        statistique: e,
                        one: ['possession'].contains(e.codeStatistique),
                      ))
                ],
              ),
            );
          },
        );
      },
    );
  }
}
