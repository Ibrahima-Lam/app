import 'package:fscore/models/game.dart';
import 'package:fscore/providers/game_event_list_provider.dart';
import 'package:fscore/widget/game/game_widget.dart';
import 'package:flutter/material.dart';

class PersonGameListWidget extends StatelessWidget {
  final List<Game> games;
  final GameEventListProvider gameEventListProvider;
  const PersonGameListWidget(
      {super.key, required this.games, required this.gameEventListProvider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 5),
          ...games
              .map((e) => GameFullWidget(
                    gameEventListProvider: gameEventListProvider,
                    game: e,
                    verticalMargin: 0,
                  ))
              .toList()
        ],
      ),
    );
  }
}
