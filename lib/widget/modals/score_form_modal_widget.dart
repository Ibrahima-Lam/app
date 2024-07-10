// ignore_for_file: must_be_immutable

import 'package:app/widget/form/elevated_button_widget.dart';
import 'package:flutter/material.dart';

class ScoreFormModalWidget extends StatelessWidget {
  int? homeScore;
  int? awayScore;
  ScoreFormModalWidget({super.key, this.homeScore, this.awayScore});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Column(
          children: [
            SizedBox(height: 10),
            StatefulBuilder(builder: (context, setState) {
              return Column(
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
                                homeScore = null;
                                awayScore = null;
                              },
                            );
                          },
                          child: Text('Initialiser')),
                      OutlinedButton(
                          onPressed: () {
                            setState(
                              () {
                                homeScore = 0;
                                awayScore = 0;
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
                                      homeScore = homeScore != null
                                          ? homeScore! + 1
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
                                      homeScore =
                                          homeScore != null && homeScore! > 0
                                              ? homeScore! - 1
                                              : null;
                                    },
                                  );
                                },
                                child: Icon(Icons.remove)),
                          ],
                        ),
                      ),
                      Container(
                        child: Text('${homeScore}-${awayScore}'),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      awayScore = awayScore != null
                                          ? awayScore! + 1
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
                                      awayScore =
                                          awayScore != null && awayScore! > 0
                                              ? awayScore! - 1
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
              );
            }),
            const SizedBox(height: 10.0),
            ElevatedButtonWidget(
              onPressed: () {
                Navigator.pop(
                    context,
                    homeScore == null || awayScore == null
                        ? null
                        : (homeScore, awayScore));
              },
            )
          ],
        );
      },
    );
  }
}
