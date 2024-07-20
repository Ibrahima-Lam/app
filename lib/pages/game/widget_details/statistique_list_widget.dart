// ignore_for_file: must_be_immutable

import 'package:app/core/constants/statistique/kStatistique.dart';
import 'package:app/models/game.dart';
import 'package:app/models/statistique.dart';
import 'package:app/providers/statistique_future_provider.dart';
import 'package:app/providers/statistique_provider.dart';
import 'package:app/widget/modals/confirm_dialog_widget.dart';
import 'package:app/widget/statistique/statistique_tile_widget.dart';
import 'package:app/widget_pages/statistique_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatistiqueListWidget extends StatefulWidget {
  final Game game;
  final bool checkUser;
  StatistiqueListWidget(
      {super.key, required this.game, required this.checkUser});

  @override
  State<StatistiqueListWidget> createState() => _StatistiqueListWidgetState();
}

class _StatistiqueListWidgetState extends State<StatistiqueListWidget> {
  void _addStat(BuildContext context, List<Statistique> stats) async {
    final (String, String)? entry = await showModalBottomSheet(
      context: context,
      builder: (context) => StatistiqueModalWidget(statistiques: stats),
    );
    if (entry == null) return;

    final Statistique statistique = kRedStatistique.copyWith(
        idStatistique: 'S${widget.game.idGame}C${entry.$1.substring(0, 2)}',
        idGame: widget.game.idGame,
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

  void _onDelete(BuildContext context, Statistique statistique) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          title: "Suppression",
          content: 'Voulez vous supprimer ce statistique ?',
        );
      },
    );
    if (confirm == true) {
      final bool res = await context
          .read<StatistiqueProvider>()
          .removeStatistique(statistique.idStatistique);

      String message = res ? 'Supprimé' : 'Echec de suppression!';
      await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(milliseconds: 200),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StatistiqueProvider>(
      builder: (context, value, child) {
        List<Statistique> statistiques = value.getGameStatistiques(widget.game);

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 5),
              ...statistiques.map((e) => StatistiqueTileWidget(
                    onDelete: (statistique) => _onDelete(context, statistique),
                    checkUser: widget.checkUser,
                    statistique: e,
                    one: ['possession'].contains(e.codeStatistique),
                  )),
              if (widget.checkUser)
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          style: ButtonStyle(
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.blue)),
                          onPressed: () {
                            _addStat(context, statistiques);
                          },
                          child: Text('Ajouter un Statistique')),
                    ],
                  ),
                ),
              if (statistiques.isEmpty)
                const Center(
                  child: Text('Pas de statistique disponible pour ce match !'),
                )
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
    'passe': 'Passes',
    'passe-reussi': 'Passes Reussis',
  };

  List<String> get keys => entries.keys
      .where((element) =>
          !widget.statistiques.any((e) => element == e.codeStatistique))
      .toList();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.9,
      initialChildSize: 0.9,
      builder: (context, scrollController) {
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
