import 'package:app/controllers/joueur/joueur_controller.dart';
import 'package:app/core/enums/categorie_enum.dart';
import 'package:app/core/enums/event_type_enum.dart';
import 'package:app/core/enums/performance_type.dart';
import 'package:app/core/extension/list_extension.dart';
import 'package:app/core/extension/string_extension.dart';
import 'package:app/core/params/categorie/categorie_params.dart';
import 'package:app/models/event.dart';
import 'package:app/models/joueur.dart';
import 'package:app/models/performance.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/app/favori_icon_widget.dart';
import 'package:app/widget/fiche/fiches_widget.dart';
import 'package:app/widget/game/card_and_num_widget.dart';
import 'package:app/widget/game/game_widget.dart';
import 'package:app/widget/logos/joueur_logo_widget.dart';
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
            FicheInfosWidget(
              categorieParams: CategorieParams(idJoueur: joueur.idJoueur),
            ),
            LastPerformanceWidget(joueur: joueur),
            InformationJoueurWidget(joueur: joueur),
            JoueurMoreinfosWidget(joueur: joueur),
            FicheSponsorWidget(
              categorieParams: CategorieParams(idJoueur: joueur.idJoueur),
            ),
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
      child: Consumer<GameProvider>(builder: (context, gameProvider, child) {
        GamePerformances? gamePerformance =
            JoueurController.getJoueurPerformance(joueur,
                    games: gameProvider.games,
                    events: gameProvider.gameEventListProvider.events)
                .lastOrNull;
        return gamePerformance == null
            ? const SizedBox()
            : Column(
                children: [
                  ...gamePerformance.performances
                      .map((e) => FichePerformanceWidget(performance: e)),
                  GameFullWidget(
                    gameEventListProvider: gameProvider.gameEventListProvider,
                    game: gamePerformance.game,
                    verticalMargin: 0.5,
                  ),
                ],
              );
      }),
    );
  }
}

class FichePerformanceWidget extends StatelessWidget {
  final Performance performance;
  const FichePerformanceWidget({super.key, required this.performance});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      child: Container(
        height: 50,
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(5.0),
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
                            joueur.participant.libelleEquipe ?? '',
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
                      PopupMenuItem(
                          child: FavoriIconWidget(
                              id: joueur.idJoueur,
                              categorie: Categorie.joueur)),
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

class JoueurMoreinfosWidget extends StatelessWidget {
  final Joueur joueur;
  const JoueurMoreinfosWidget({super.key, required this.joueur});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, gameProvider, child) {
      List<EventStatistique> eventStatistiques =
          JoueurController.getJoueurStatistique(joueur,
                  events: gameProvider.gameEventListProvider.events)
              .where((element) => element.nombre > 0)
              .toList();
      int jaune = eventStatistiques
              .singleWhereOrNull<EventStatistique>(
                  (element) => element.type == EventType.jaune)
              ?.nombre ??
          0;
      int rouge = eventStatistiques
              .singleWhereOrNull<EventStatistique>(
                  (element) => element.type == EventType.rouge)
              ?.nombre ??
          0;
      int but = eventStatistiques
              .singleWhereOrNull<EventStatistique>(
                  (element) => element.type == EventType.but)
              ?.nombre ??
          0;
      return Card(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 90,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                JoueurMoreinfosColumnWidget(
                  content: null,
                  icon: Icon(Icons.gamepad),
                  label: 'Matchs',
                ),
                JoueurMoreinfosColumnWidget(
                  content: but.toString(),
                  icon: Icon(Icons.sports_soccer, color: Colors.green),
                  label: 'Buts',
                ),
                JoueurMoreinfosColumnWidget(
                  content: null,
                  icon: Icon(Icons.send_rounded, color: Colors.blue),
                  label: 'Passes',
                ),
                JoueurMoreinfosColumnWidget(
                  content: jaune.toString(),
                  icon: CardAndNumberWidget(
                      yellow: true, showOneNumber: false, nombre: 1),
                  label: 'Cartons J.',
                ),
                JoueurMoreinfosColumnWidget(
                  content: rouge.toString(),
                  icon: CardAndNumberWidget(
                      yellow: false, showOneNumber: false, nombre: 1),
                  label: 'Cartons R.',
                ),
                JoueurMoreinfosColumnWidget(
                    content: joueur.age != null
                        ? '${joueur.age.toString()} ans'
                        : null,
                    icon: Icon(Icons.calendar_view_month),
                    label: 'Age'),
                JoueurMoreinfosColumnWidget(
                  content: joueur.poids != null
                      ? '${joueur.poids.toString()} kg'
                      : null,
                  icon: Icon(Icons.line_weight_outlined),
                  label: 'Poids',
                ),
                JoueurMoreinfosColumnWidget(
                  content: joueur.taille != null
                      ? '${joueur.taille.toString()} m'
                      : null,
                  icon: Icon(Icons.height),
                  label: 'Taille',
                ),
                JoueurMoreinfosColumnWidget(
                  content: joueur.vitesse != null
                      ? '${joueur.vitesse.toString()} km/h'
                      : null,
                  icon: Icon(Icons.speed),
                  label: 'Vitesse',
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class JoueurMoreinfosColumnWidget extends StatelessWidget {
  final String label;
  final String? content;
  final Widget icon;
  const JoueurMoreinfosColumnWidget(
      {super.key,
      required this.content,
      required this.icon,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: 80,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          icon,
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            content ?? '?',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
