import 'package:app/controllers/joueur/joueur_controller.dart';
import 'package:app/core/enums/performance_type.dart';
import 'package:app/core/extension/string_extension.dart';
import 'package:app/models/joueur.dart';
import 'package:app/models/performance.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/fiches_widget.dart';
import 'package:app/widget/game_widget.dart';
import 'package:app/widget/joueur_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoueurFicheListWidget extends StatelessWidget {
  final Joueur joueur;
  const JoueurFicheListWidget({super.key, required this.joueur});

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
            FicheInfosWidget(idJoueur: joueur.idJoueur),
            LastPerformanceWidget(joueur: joueur),
            InformationJoueurWidget(joueur: joueur),
            FicheSponsorWidget(idJoueur: joueur.idJoueur),
          ],
        ),
      ),
    );
  }
}

class LastPerformanceWidget extends StatelessWidget {
  final Joueur joueur;
  const LastPerformanceWidget({super.key, required this.joueur});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Card(
        child: Consumer2<GameProvider, GameEventListProvider>(
            builder: (context, matchs, events, child) {
          GamePerformances? gamePerformance =
              JoueurController.getJoueurPerformance(joueur,
                      games: matchs.gameCollection.games, events: events.events)
                  .lastOrNull;
          return gamePerformance == null
              ? const SizedBox()
              : Column(
                  children: [
                    ...gamePerformance.performances
                        .map((e) => FichePerformanceWidget(performance: e)),
                    GameFullWidget(game: gamePerformance.game),
                  ],
                );
        }),
      ),
    );
  }
}

class FichePerformanceWidget extends StatelessWidget {
  final Performance performance;
  const FichePerformanceWidget({super.key, required this.performance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(5.0),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            performance.title.capitalize(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Row(
            children: List.generate(
                performance.nombre,
                (index) => Icon(performance.type == PerformanceType.but
                    ? Icons.sports_soccer
                    : Icons.arrow_forward)),
          )
        ],
      ),
    );
  }
}

class InformationJoueurWidget extends StatelessWidget {
  final Joueur joueur;
  const InformationJoueurWidget({super.key, required this.joueur});

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
                    child: JoueurImageLogoWidget(url: joueur.imageUrl),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            joueur.nomJoueur,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            joueur.libelleEquipe ?? '',
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
                          'images/messi.jpg',
                        )),
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
