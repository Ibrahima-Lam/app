import 'package:app/core/constants/statistique/kStatistique.dart';
import 'package:app/models/game.dart';
import 'package:app/models/statistique.dart';
import 'package:app/providers/statistique_future_provider.dart';
import 'package:app/providers/statistique_provider.dart';
import 'package:app/widget/stat_widget.dart';
import 'package:app/widget_pages/statistique_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatistiqueWidget extends StatelessWidget {
  final Game game;
  const StatistiqueWidget({super.key, required this.game});

  void _addStat(BuildContext context, List<Statistique> stats) async {
    final (String, String)? entry = await showModalBottomSheet(
      context: context,
      builder: (context) => StatistiqueModalWidget(statistiques: stats),
    );
    if (entry == null) return;

    final Statistique statistique = kRedStatistique.copyWith(
        idStatistique: 'S${game.idGame}C${entry.$1.substring(0, 2)}',
        idGame: game.idGame,
        codeStatistique: entry.$1,
        nomStatistique: entry.$2);
    final bool? isSubmited = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StatistiqueForm(
          statistique: statistique,
        ),
      ),
    );
    if (isSubmited ?? false)
      context.read<StatistiqueFutureProvider>().addStat(statistique);
  }

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
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        _addStat(context, statistiques);
                      },
                      child: Text('Ajouter')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class StatistiqueModalWidget extends StatefulWidget {
  final List<Statistique> statistiques;

  StatistiqueModalWidget({super.key, required this.statistiques});

  @override
  State<StatistiqueModalWidget> createState() => _StatistiqueModalWidgetState();
}

class _StatistiqueModalWidgetState extends State<StatistiqueModalWidget>
    with TickerProviderStateMixin {
  final Map<String, String> entries = {
    'possession': 'Possessions',
    'corner': 'Corners',
    'touche': 'Touches',
    'occasion': 'Occasions',
    'jaune': 'Cartons Jaunes',
    'rouge': 'Cartons Rouges',
    'tir': 'Tirs',
    'tir-cadre': 'Tirs Cadrés',
    'faute': 'Fautes',
    'hors-jeu': 'Hors Jeu',
  };

  List<String> get keys => entries.keys
      .where((element) =>
          !widget.statistiques.any((e) => element == e.codeStatistique))
      .toList();

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      animationController: BottomSheet.createAnimationController(this),
      onClosing: () {},
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 20),
          constraints: const BoxConstraints(minHeight: 600),
          child: ListView(children: [
            if (keys.isEmpty)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: const Text(
                      'Tous les élément sont deja disponible, veuillez supprimer ou modifier !!'),
                ),
              ),
            ...entries.keys
                .map((e) => OutlinedButton(
                      onPressed:
                          widget.statistiques.any((s) => e == s.codeStatistique)
                              ? null
                              : () {
                                  Navigator.pop(context, (e, entries[e] ?? ''));
                                },
                      child: Text(entries[e] ?? ''),
                    ))
                .toList(),
          ]),
        );
      },
    );
  }
}
