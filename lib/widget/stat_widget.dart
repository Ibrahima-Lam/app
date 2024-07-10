import 'package:app/models/statistique.dart';
import 'package:app/providers/statistique_provider.dart';
import 'package:app/widget_pages/statistique_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatWidget extends StatelessWidget {
  final Statistique statistique;
  final bool one;
  final bool checkUser;
  const StatWidget(
      {super.key,
      required this.statistique,
      this.one = true,
      this.checkUser = false});

  final TextStyle style = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  bool get isPossession => statistique.codeStatistique == 'possession';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: checkUser
          ? () async {
              final bool? isSubmited =
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StatistiqueForm(
                            statistique: statistique,
                          )));
              if (isSubmited ?? false)
                context.read<StatistiqueProvider>().setStat(statistique);
            }
          : null,
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: const Border(
              top: BorderSide(width: 0.5, color: Colors.grey),
              bottom: BorderSide(width: 0.5, color: Colors.grey)),
        ),
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(minHeight: 40),
              child: Row(
                children: [
                  Expanded(
                      child: TextContentWiget(
                    content:
                        '${statistique.homeStatistique.toInt().toString()}${isPossession ? '%' : ''}',
                    color: statistique.homeStatistique >=
                            statistique.awayStatistique
                        ? Colors.blueAccent
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
                        ? Colors.greenAccent
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
