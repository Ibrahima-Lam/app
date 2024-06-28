// ignore_for_file: must_be_immutable

import 'package:app/models/game.dart';
import 'package:app/models/participant.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/widget/game_widget.dart';
import 'package:app/widget/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSearchPage extends StatelessWidget {
  GameSearchPage({super.key});
  final TextEditingController homeController = TextEditingController();
  final TextEditingController awayController = TextEditingController();
  List<Participant> participants = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche de match'),
      ),
      body: Column(
        children: [
          Autocomplete<Participant>(
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text.isEmpty)
                return Iterable<Participant>.empty();
              return participants.where((element) => element.nomEquipe
                  .toUpperCase()
                  .startsWith(textEditingValue.text.toUpperCase()));
            },
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) =>
                    TextField(
              controller: textEditingController,
              focusNode: focusNode,
            ),
            optionsViewBuilder: (context, onSelected, options) {
              return Material(
                child: ListView(
                  children: options
                      .map((e) => ListTile(
                            title: Text(e.nomEquipe),
                            onTap: () {
                              onSelected(e);
                            },
                          ))
                      .toList(),
                ),
              );
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextFieldWidget(
                  textEditingController: homeController,
                  hintText: 'Entrer une equipe',
                ),
              ),
              Expanded(
                child: TextFieldWidget(
                  textEditingController: awayController,
                  hintText: 'Entrer une equipe',
                ),
              )
            ],
          ),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              child: Container(
                child: FutureBuilder(
                  future: context.read<GameProvider>().getGames(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('erreur!'),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Consumer2<GameProvider, ParticipantProvider>(
                      builder: (context, matchs, equipes, child) {
                        List<Game> games = matchs.gameCollection.games;
                        participants = equipes.participants;
                        return ListenableBuilder(
                            listenable: homeController,
                            builder: (context, child) {
                              return ListenableBuilder(
                                  listenable: awayController,
                                  builder: (context, child) {
                                    List<Game> elements = homeController
                                                .text.isEmpty ||
                                            awayController.text.isEmpty
                                        ? []
                                        : games
                                            .where((element) =>
                                                element.home!.toUpperCase().contains(homeController.text.toUpperCase()) &&
                                                    element.away!
                                                        .toUpperCase()
                                                        .contains(awayController
                                                            .text
                                                            .toUpperCase()) ||
                                                element.home!.toUpperCase().contains(awayController.text.toUpperCase()) &&
                                                    element.away!
                                                        .toUpperCase()
                                                        .contains(
                                                            homeController.text.toUpperCase()))
                                            .toList();
                                    return elements.isEmpty
                                        ? Center(
                                            child: Text(homeController
                                                        .text.isEmpty ||
                                                    awayController.text.isEmpty
                                                ? 'Renseigner les deux champs svp!'
                                                : 'Pas de correspondance!'))
                                        : SingleChildScrollView(
                                            child: Column(
                                              children: elements
                                                  .map((e) =>
                                                      GameWidget(game: e))
                                                  .toList(),
                                            ),
                                          );
                                  });
                            });
                      },
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
