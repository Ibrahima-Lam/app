import 'package:app/controllers/competition/date.dart';
import 'package:app/core/enums/categorie_enum.dart';
import 'package:app/models/game.dart';
import 'package:app/models/joueur.dart';
import 'package:app/models/participant.dart';
import 'package:app/pages/game/game_details.dart';
import 'package:app/pages/joueur/joueur_details.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/circular_logo_widget.dart';
import 'package:app/widget/equipe_logo_widget.dart';
import 'package:app/widget/fiches_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EquipeFicheListWidget extends StatelessWidget {
  final Participant participant;
  const EquipeFicheListWidget({super.key, required this.participant});

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
            FicheInfosWidget(idPartcipant: participant.idParticipant),
            SomePlayerWidget(idPartcipant: participant.idParticipant),
            LastGameWidget(idParticipant: participant.idParticipant),
            NextGameWidget(idParticipant: participant.idParticipant),
            InformationEquipeWidget(participant: participant),
            MoreInfosWidget(idPartcipant: participant.idParticipant),
            FicheSponsorWidget(idPartcipant: participant.idParticipant),
          ],
        ),
      ),
    );
  }
}

class MoreInfosWidget extends StatelessWidget {
  final String idPartcipant;
  const MoreInfosWidget({super.key, required this.idPartcipant});
  final double size = 30.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Card(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Consumer<GameProvider>(builder: (context, val, child) {
              final List<Game> games = val.gameCollection
                  .getGamesBy(idPartcipant: idPartcipant)
                  .where((element) => element.isPlayed)
                  .toList();

              final int m = games.length;
              int v = 0;
              int n = 0;
              int d = 0;
              int bm = 0;
              int be = 0;
              for (Game game in games) {
                if (game.homeScore == game.awayScore) {
                  n++;
                  if (idPartcipant == game.idHome) {
                    bm += game.homeScore ?? 0;
                    be += game.awayScore ?? 0;
                  } else {
                    bm += game.awayScore ?? 0;
                    be += game.homeScore ?? 0;
                  }
                  continue;
                }
                if (idPartcipant == game.idHome) {
                  if (game.isHomeVictoire)
                    v++;
                  else
                    d++;
                  bm += game.homeScore ?? 0;
                  be += game.awayScore ?? 0;
                  continue;
                } else {
                  if (game.isAwayVictoire)
                    v++;
                  else
                    d++;
                  bm += game.awayScore ?? 0;
                  be += game.homeScore ?? 0;
                  continue;
                }
              }
              final List<Map<String, Object>> list = [
                {
                  'title': 'Matchs',
                  'nombre': m,
                  'icon': Icon(size: size, Icons.gamepad)
                },
                {
                  'title': 'Victoires',
                  'nombre': v,
                  'icon': Icon(
                      size: size, Icons.check_box_outlined, color: Colors.green)
                },
                {
                  'title': 'Defaites',
                  'nombre': d,
                  'icon': Icon(size: size, Icons.clear, color: Colors.red)
                },
                {
                  'title': 'Matchs Null',
                  'nombre': n,
                  'icon': Icon(size: size, Icons.graphic_eq, color: Colors.grey)
                },
                {
                  'title': 'Buts M.',
                  'nombre': bm,
                  'icon':
                      Icon(size: size, Icons.sports_soccer, color: Colors.cyan)
                },
                {
                  'title': 'Buts E.',
                  'nombre': be,
                  'icon':
                      Icon(size: size, Icons.sports_soccer, color: Colors.grey)
                },
              ];
              return Row(
                children: [
                  ...list.map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (e['icon'] is Widget) e['icon'] as Widget,
                              Text((e['nombre'] as int).toString()),
                            ],
                          ),
                          Text((e['title'] as String))
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class InformationEquipeWidget extends StatelessWidget {
  final Participant participant;
  const InformationEquipeWidget({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
          height: 300,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    child: EquipeImageLogoWidget(url: participant.imageUrl),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            participant.nomEquipe,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            participant.libelleEquipe ?? '',
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
                          'images/photo.jpg',
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
                            Text(participant.nomCompetition ?? ''),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.place),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(participant.localiteEquipe ??
                                participant.localiteCompetition ??
                                ''),
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
  }
}

class SomePlayerWidget extends StatelessWidget {
  final String idPartcipant;
  const SomePlayerWidget({super.key, required this.idPartcipant});

  @override
  Widget build(BuildContext context) {
    return Consumer<JoueurProvider>(builder: (context, value, child) {
      List<Joueur> joueurs = value.joueurs
          .where((element) => element.idParticipant == idPartcipant)
          .take(5)
          .toList();
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...joueurs.map((e) => GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            JoueurDetails(idJoueur: e.idJoueur))),
                    child: CircularLogoWidget(
                        path: e.imageUrl ?? '', categorie: Categorie.joueur),
                  )),
              ...List.generate(
                  5 - joueurs.length,
                  (index) => CircularLogoWidget(
                        path: '',
                        categorie: Categorie.joueur,
                      )),
            ],
          ),
        ),
      );
    });
  }
}

class LastGameWidget extends StatelessWidget {
  final String idParticipant;
  const LastGameWidget({super.key, required this.idParticipant});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, val, child) {
      Game? game;
      try {
        game = val.gameCollection.played.lastWhere((element) =>
            element.idHome == idParticipant || element.idAway == idParticipant);
      } catch (e) {}
      return game == null
          ? const SizedBox()
          : FicheGameWidget(
              game: game,
            );
    });
  }
}

class NextGameWidget extends StatelessWidget {
  final String idParticipant;
  const NextGameWidget({super.key, required this.idParticipant});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, val, child) {
      Game? game;
      try {
        game = val.gameCollection.noPlayed.firstWhere((element) =>
            element.idHome == idParticipant || element.idAway == idParticipant);
      } catch (e) {}
      return game == null
          ? const SizedBox()
          : FicheGameWidget(
              game: game,
            );
    });
  }
}

class FicheGameWidget extends StatelessWidget {
  final Game game;

  const FicheGameWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GameDetails(id: game.idGame)));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: equipeWidget(game.home!, game.homeImage ?? ''),
                ),
                Container(
                  constraints: BoxConstraints(minHeight: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(game.nomNiveau ?? ''),
                      Text(
                        game.score,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateController.frDate(game.dateGame, abbr: true),
                        style: const TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
                Expanded(child: equipeWidget(game.away!, game.awayImage ?? '')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget equipeWidget(String name, String imageUrl) => Column(
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: EquipeImageLogoWidget(
              url: imageUrl,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(name),
        ],
      );
}
