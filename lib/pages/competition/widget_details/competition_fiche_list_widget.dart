import 'package:app/core/enums/categorie_enum.dart';
import 'package:app/core/params/categorie/categorie_params.dart';
import 'package:app/models/competition.dart';
import 'package:app/models/game.dart';
import 'package:app/models/participant.dart';
import 'package:app/pages/equipe/equipe_details.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/widget/logos/circular_logo_widget.dart';
import 'package:app/widget/logos/competition_logo_image.dart';
import 'package:app/widget/fiche/fiches_widget.dart';
import 'package:app/widget/game/game_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompetitionFicheListWidget extends StatelessWidget {
  final String idEdition;
  const CompetitionFicheListWidget({super.key, required this.idEdition});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          cardTheme: CardTheme(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FicheInfosWidget(
              categorieParams: CategorieParams(idEdition: idEdition),
            ),
            SomeTeamWidget(idEdition: idEdition),
            CompetitionFichePreviousGameWidget(idEdition: idEdition),
            CompetitionFicheNextGameWidget(idEdition: idEdition),
            InformationCompetitionWidget(idEdition: idEdition),
            FicheSponsorWidget(
              categorieParams: CategorieParams(idEdition: idEdition),
            ),
          ],
        ),
      ),
    );
  }
}

class SomeTeamWidget extends StatelessWidget {
  final String idEdition;
  const SomeTeamWidget({super.key, required this.idEdition});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<ParticipantProvider>().getParticipants(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('erreur!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<ParticipantProvider>(
              builder: (context, value, child) {
            List<Participant> participants = value.participants
                .where((element) => element.codeEdition == idEdition)
                .toList();
            return participants.isEmpty
                ? const SizedBox()
                : Container(
                    width: MediaQuery.sizeOf(context).width,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 5.0),
                    color: Colors.white,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...participants.map((e) => GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => EquipeDetails(
                                            id: e.idParticipant))),
                                child: CircularLogoWidget(
                                    path: e.imageUrl ?? '',
                                    categorie: Categorie.equipe),
                              )),
                        ],
                      ),
                    ),
                  );
          });
        });
  }
}

class InformationCompetitionWidget extends StatelessWidget {
  final String idEdition;
  InformationCompetitionWidget({super.key, required this.idEdition});
  late final Competition? competition;

  @override
  Widget build(BuildContext context) {
    return Consumer<CompetitionProvider>(builder: (context, val, child) {
      try {
        competition = val.collection.competitions
            .firstWhere((element) => element.codeEdition == idEdition);
      } catch (e) {
        competition = null;
      }
      if (competition == null) return const SizedBox();
      return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Card(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
            height: 300,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      child: CompetitionImageLogoWidget(
                          url: competition!.imageUrl),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              competition!.nomEdition ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              competition!.localiteCompetition ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    //Todo
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(child: Text('Ajouter au favori')),
                        PopupMenuItem(child: Text('Voir plus')),
                        PopupMenuItem(child: Text('Contacter')),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 5.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'images/trophee.jpg',
                          )),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.house),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(competition!.nomCompetition),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.place),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(competition!.localiteCompetition ?? ''),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.calendar_month),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(competition!.anneeEdition ?? ''),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class CompetitionFichePreviousGameWidget extends StatelessWidget {
  final String idEdition;
  const CompetitionFichePreviousGameWidget(
      {super.key, required this.idEdition});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, gameProvider, child) {
      Game? game;
      try {
        game = gameProvider.played.lastWhere((element) =>
            element.groupe.codeEdition == idEdition ||
            element.idAway == idEdition);
      } catch (e) {}
      return game == null
          ? const SizedBox()
          : GameFullWidget(
              game: game,
              gameEventListProvider: gameProvider.gameEventListProvider,
            );
    });
  }
}

class CompetitionFicheNextGameWidget extends StatelessWidget {
  final String idEdition;
  const CompetitionFicheNextGameWidget({super.key, required this.idEdition});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, gameProvider, child) {
      Game? game;
      try {
        game = gameProvider.noPlayed
            .firstWhere((element) => element.groupe.codeEdition == idEdition);
      } catch (e) {}
      return game == null
          ? const SizedBox()
          : GameFullWidget(
              game: game,
              gameEventListProvider: gameProvider.gameEventListProvider,
            );
    });
  }
}
