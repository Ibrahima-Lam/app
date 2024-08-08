// ignore_for_file: must_be_immutable

import 'package:app/models/scores/score.dart';
import 'package:app/widget/form/elevated_button_widget.dart';
import 'package:flutter/material.dart';

class ScoreFormModalWidget extends StatefulWidget {
  final String idGame;
  final bool isPenalty;
  ScoreFormModalWidget(
      {super.key,
      required this.idGame,
      required this.score,
      required this.isPenalty});

  final Score? score;

  @override
  State<ScoreFormModalWidget> createState() => _ScoreFormModalWidgetState();
}

class _ScoreFormModalWidgetState extends State<ScoreFormModalWidget> {
  late Score score;
  @override
  void initState() {
    score = widget.score ?? Score(idGame: widget.idGame);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Column(
          children: [
            SizedBox(height: 10),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Annuler')),
                    OutlinedButton(
                        onPressed: () {
                          setState(
                            () {
                              score.homeScore = null;
                              score.awayScore = null;
                            },
                          );
                        },
                        child: Text('Initialiser')),
                    OutlinedButton(
                        onPressed: () {
                          setState(
                            () {
                              score.homeScore = 0;
                              score.awayScore = 0;
                            },
                          );
                        },
                        child: Text('0-0'))
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                setState(
                                  () {
                                    score.homeScore = score.homeScore != null
                                        ? score.homeScore! + 1
                                        : 0;
                                  },
                                );
                              },
                              child: Icon(Icons.add)),
                          const SizedBox(height: 10.0),
                          OutlinedButton(
                              onPressed: () {
                                setState(
                                  () {
                                    score.homeScore = score.homeScore != null &&
                                            score.homeScore! > 0
                                        ? score.homeScore! - 1
                                        : null;
                                  },
                                );
                              },
                              child: Icon(Icons.remove)),
                        ],
                      ),
                    ),
                    Container(
                      child: Text('${score.homeScore}-${score.awayScore}'),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                setState(
                                  () {
                                    score.awayScore = score.awayScore != null
                                        ? score.awayScore! + 1
                                        : 0;
                                  },
                                );
                              },
                              child: Icon(Icons.add)),
                          const SizedBox(height: 10.0),
                          OutlinedButton(
                              onPressed: () {
                                setState(
                                  () {
                                    score.awayScore = score.awayScore != null &&
                                            score.awayScore! > 0
                                        ? score.awayScore! - 1
                                        : null;
                                  },
                                );
                              },
                              child: Icon(Icons.remove)),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            widget.isPenalty
                ? ScorePenaltyFormModalWidget(
                    score: score,
                    onScoreChanged: (homeScore, awayScore) {
                      setState(() {
                        score.homeScorePenalty = homeScore;
                        score.awayScorePenalty = awayScore;
                      });
                    },
                  )
                : const SizedBox(),
            const SizedBox(height: 10.0),
            ElevatedButtonWidget(
              onPressed: () {
                Navigator.pop(context, score);
              },
            )
          ],
        );
      },
    );
  }
}

class ScorePenaltyFormModalWidget extends StatelessWidget {
  final Score score;
  final Function(int?, int?) onScoreChanged;
  const ScorePenaltyFormModalWidget(
      {super.key, required this.score, required this.onScoreChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Tir au but',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    onPressed: () {
                      onScoreChanged(null, null);
                    },
                    child: Text('Initialiser')),
                OutlinedButton(
                    onPressed: () {
                      onScoreChanged(0, 0);
                    },
                    child: Text('0-0'))
              ],
            )
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  OutlinedButton(
                      onPressed: () {
                        onScoreChanged(
                            score.homeScorePenalty != null
                                ? score.homeScorePenalty! + 1
                                : 0,
                            score.awayScorePenalty);
                      },
                      child: Icon(Icons.add)),
                  const SizedBox(height: 10.0),
                  OutlinedButton(
                      onPressed: () {
                        onScoreChanged(
                            score.homeScorePenalty != null &&
                                    score.homeScorePenalty! > 0
                                ? score.homeScorePenalty! - 1
                                : null,
                            score.awayScorePenalty);
                      },
                      child: Icon(Icons.remove)),
                ],
              ),
            ),
            Container(
              child:
                  Text('${score.homeScorePenalty}-${score.awayScorePenalty}'),
            ),
            Expanded(
              child: Column(
                children: [
                  OutlinedButton(
                      onPressed: () {
                        onScoreChanged(
                            score.homeScorePenalty,
                            score.awayScorePenalty != null
                                ? score.awayScorePenalty! + 1
                                : 0);
                      },
                      child: Icon(Icons.add)),
                  const SizedBox(height: 10.0),
                  OutlinedButton(
                      onPressed: () {
                        onScoreChanged(
                            score.homeScorePenalty,
                            score.awayScorePenalty != null &&
                                    score.awayScorePenalty! > 0
                                ? score.awayScorePenalty! - 1
                                : null);
                      },
                      child: Icon(Icons.remove)),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
