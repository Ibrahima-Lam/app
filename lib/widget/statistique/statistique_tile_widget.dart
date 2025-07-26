import 'package:fscore/models/statistique.dart';
import 'package:fscore/providers/statistique_future_provider.dart';
import 'package:fscore/widget_pages/statistique_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class StatistiqueTileWidget extends StatelessWidget {
  final Statistique statistique;
  final bool one;
  final bool checkUser;
  final Function(Statistique statistique) onDelete;
  const StatistiqueTileWidget(
      {super.key,
      required this.statistique,
      this.one = true,
      this.checkUser = false,
      required this.onDelete});

  final TextStyle style = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  bool get isPossession => statistique.codeStatistique == 'possession';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: checkUser && !statistique.isFromEvent
          ? () async {
              final bool? isSubmited =
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StatistiqueForm(
                            statistique: statistique,
                          )));
              if (isSubmited ?? false)
                context
                    .read<StatistiqueFutureProvider>()
                    .editStatistique(statistique.idStatistique, statistique);
            }
          : null,
      child: Slidable(
        key: ValueKey(statistique.idStatistique),
        enabled: checkUser && !statistique.isFromEvent,
        startActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: (context) => onDelete(statistique),
              icon: Icons.delete,
              foregroundColor: Colors.red,
            ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          shadowColor: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: TextContentWiget(
                        content:
                            '${statistique.homeStatistique.toInt().toString()}${isPossession ? '%' : ''}',
                        color: statistique.homeStatistique >=
                                statistique.awayStatistique
                            ? Color.fromARGB(255, 146, 183, 248)
                            : null,
                      )),
                      Center(
                        child: Text(
                          statistique.nomStatistique,
                          style: style,
                        ),
                      ),
                      Expanded(
                          child: TextContentWiget(
                        content:
                            '${statistique.awayStatistique.toInt().toString()}${isPossession ? '%' : ''}',
                        color: statistique.homeStatistique <=
                                statistique.awayStatistique
                            ? const Color.fromARGB(255, 194, 244, 220)
                            : null,
                      )),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(2),
                          backgroundColor: one ? Colors.greenAccent : null,
                          color: Colors.blueAccent,
                          value: statistique.homeStatistique +
                                      statistique.awayStatistique <=
                                  0
                              ? 0
                              : statistique.homeStatistique /
                                  (statistique.homeStatistique +
                                      statistique.awayStatistique),
                        ),
                      ),
                    ),
                    if (!one)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.greenAccent,
                              value: statistique.homeStatistique +
                                          statistique.awayStatistique <=
                                      0
                                  ? 0
                                  : statistique.awayStatistique /
                                      (statistique.homeStatistique +
                                          statistique.awayStatistique),
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextContentWiget extends StatelessWidget {
  final String content;
  final Color? color;
  const TextContentWiget({super.key, required this.content, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 30,
        width: 50,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10.0)),
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
