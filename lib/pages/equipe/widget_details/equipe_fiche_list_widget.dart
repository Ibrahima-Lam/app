import 'package:app/controllers/competition/date.dart';
import 'package:app/models/game.dart';
import 'package:app/models/participant.dart';
import 'package:app/pages/game/game_details.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/equipe_logo_widget.dart';
import 'package:app/widget/joueur_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      child: Container(
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
                    //Todos url de l' equipe
                    child: EquipeImageLogoWidget(),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...List.generate(
                5, (index) => CircularLogoWidget(path: 'images/messi.jpg')),
          ],
        ),
      ),
    );
  }
}

class CircularLogoWidget extends StatelessWidget {
  final String path;

  final double? size;
  const CircularLogoWidget({super.key, required this.path, this.size});

  @override
  Widget build(BuildContext context) {
    final s = size != null ? Size(size!, size!) : Size(70, 70);
    return Container(
      height: s.height,
      width: s.width,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: PhysicalModel(
        elevation: 5,
        shape: BoxShape.circle,
        color: Colors.white,
        child: Container(
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: JoueurImageLogoWidget(url: path)),
      ),
    );
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
              title: 'Dernier match',
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
              title: 'Prochain match',
            );
    });
  }
}

class FicheGameWidget extends StatelessWidget {
  final Game game;
  final String title;
  const FicheGameWidget({super.key, required this.game, required this.title});

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
              children: [
                Expanded(
                  child: equipeWidget(game.home!, game.homeImage ?? ''),
                ),
                Container(
                  constraints: BoxConstraints(minHeight: 80),
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
                      Text(DateController.frDate(game.dateGame, abbr: true))
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

class FicheInfosWidget extends StatelessWidget {
  final String idPartcipant;
  const FicheInfosWidget({super.key, required this.idPartcipant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Card(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          constraints: const BoxConstraints(
            minHeight: 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: '',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.asset('images/messi.jpg'),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Text(
                  'a la une de cette equipe elle a perdu son premier de la competition face a son dephin! ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FicheSponsorWidget extends StatelessWidget {
  final String idPartcipant;
  const FicheSponsorWidget({super.key, required this.idPartcipant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Card(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          constraints: const BoxConstraints(
            minHeight: 200,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: '',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.asset('images/messi.jpg'),
              ),
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('sponsor officielle'))
            ],
          ),
        ),
      ),
    );
  }
}
