// ignore_for_file: must_be_immutable

import 'package:app/models/game.dart';
import 'package:app/models/participant.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/widget/game/game_widget.dart';
import 'package:app/widget/form/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSearchPage extends StatefulWidget {
  GameSearchPage({super.key});

  @override
  State<GameSearchPage> createState() => _GameSearchPageState();
}

class _GameSearchPageState extends State<GameSearchPage> {
  final FocusNode homeFocusNode = FocusNode();
  final FocusNode awayFocusNode = FocusNode();
  late final TextEditingController homeController;

  late final TextEditingController awayController;

  String? idHome;

  String? idAway;
  bool showHome = false;
  bool showAway = false;
  @override
  void initState() {
    homeController = TextEditingController()
      ..addListener(() {
        if (homeController.text.isEmpty) {
          setState(() {
            showHome = false;
          });
        } else if (!showHome) {
          setState(() {
            showHome = true;
          });
        }
      });
    awayController = TextEditingController()
      ..addListener(() {
        if (awayController.text.isEmpty) {
          setState(() {
            showAway = false;
          });
        } else if (!showAway) {
          setState(() {
            showAway = true;
          });
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche de match'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFieldWidget(
                  focusNode: homeFocusNode,
                  textEditingController: homeController,
                  hintText: 'Entrer une equipe',
                ),
              ),
              Expanded(
                child: TextFieldWidget(
                  focusNode: awayFocusNode,
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
                child: Stack(
                  children: [
                    FutureBuilder(
                      future: context.read<GameProvider>().getGames(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('erreur!'),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Consumer<GameProvider>(
                          builder: (context, matchs, child) {
                            List<Game> games = matchs.games;

                            return Builder(builder: (context) {
                              List<Game> elements =
                                  homeController.text.isEmpty ||
                                          awayController.text.isEmpty
                                      ? []
                                      : games
                                          .where((element) =>
                                              element.idHome == idHome &&
                                                  element.idAway == idAway ||
                                              element.idHome == idAway &&
                                                  element.idAway == idHome)
                                          .toList();
                              return elements.isEmpty
                                  ? Center(
                                      child: Text(homeController.text.isEmpty ||
                                              awayController.text.isEmpty
                                          ? 'Renseigner les deux champs svp!'
                                          : 'Pas de correspondance de match!'))
                                  : SingleChildScrollView(
                                      child: Column(
                                        children: elements
                                            .map((e) => GameWidget(game: e))
                                            .toList(),
                                      ),
                                    );
                            });
                          },
                        );
                      },
                    ),
                    if (showHome)
                      Positioned(
                        child: EquipeSearchListWidget(
                          controller: homeController,
                          onSelected: (e) {
                            setState(() {
                              homeFocusNode.canRequestFocus = false;
                              idHome = e.idParticipant;
                              homeController.text = e.nomEquipe;
                              showHome = false;
                            });
                          },
                        ),
                      ),
                    if (showAway)
                      Positioned(
                        child: EquipeSearchListWidget(
                          controller: awayController,
                          onSelected: (e) {
                            setState(() {
                              awayFocusNode.canRequestFocus = false;
                              idAway = e.idParticipant;
                              awayController.text = e.nomEquipe;
                              showHome = false;
                              showAway = false;
                            });
                          },
                        ),
                      )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class EquipeSearchListWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(Participant) onSelected;
  const EquipeSearchListWidget(
      {super.key, required this.controller, required this.onSelected});

  @override
  State<EquipeSearchListWidget> createState() => _EquipeSearchListWidgetState();
}

class _EquipeSearchListWidgetState extends State<EquipeSearchListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: FutureBuilder(
          future: context.read<ParticipantProvider>().getParticipants(),
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
            final List<Participant> participants = snapshot.data ?? [];
            return ListenableBuilder(
                listenable: widget.controller,
                builder: (context, child) {
                  final List<Participant> elements = participants
                      .where((element) => element.nomEquipe
                          .toUpperCase()
                          .contains(widget.controller.text.toUpperCase()))
                      .toList();
                  if (elements.isEmpty && !widget.controller.text.isEmpty) {
                    return const Center(
                      child: Text(
                        'Pas de correspondance de l\'équipe trouvée!',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return ListView(
                    children: elements
                        .map((e) => ListTile(
                              title: Text(e.nomEquipe),
                              onTap: () {
                                widget.onSelected(e);
                              },
                            ))
                        .toList(),
                  );
                });
          }),
    );
  }
}
