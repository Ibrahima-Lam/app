import 'package:app/core/enums/event_type_enum.dart';
import 'package:app/core/enums/performance_type.dart';
import 'package:app/models/composition.dart';
import 'package:app/models/event.dart';
import 'package:app/models/game.dart';
import 'package:app/models/joueur.dart';
import 'package:app/models/performance.dart';

class JoueurController {
  static List<Game> getJoueurConvocation(
    String idJoueur, {
    required List<JoueurComposition> compositions,
    required List<Game> games,
  }) {
    List<JoueurComposition> compos =
        compositions.where((element) => element.idJoueur == idJoueur).toList();
    return games
        .where((element) => compos.any((e) => e.idGame == element.idGame))
        .toList();
  }

  static List<GamePerformances> getJoueurPerformance(
    Joueur joueur, {
    required List<Game> games,
    required List<Event> events,
  }) {
    events = events
        .whereType<GoalEvent>()
        .where((element) =>
            element.idJoueur == joueur.idJoueur ||
            element.idTarget == joueur.idJoueur)
        .toList();
    games = games
        .where((element) => events.any((e) => e.idGame == element.idGame))
        .toList();
    List<GamePerformances> performances = [];
    for (Game game in games) {
      int but = events.fold(
          0,
          (previousValue, element) =>
              previousValue +
              (element.idGame == game.idGame &&
                      element.idJoueur == joueur.idJoueur
                  ? 1
                  : 0));
      int passe = events.fold(
          0,
          (previousValue, element) =>
              previousValue +
              (element.idGame == game.idGame &&
                      element.idTarget == joueur.idJoueur
                  ? 1
                  : 0));
      performances.add(GamePerformances(game: game, performances: [
        if (but > 0)
          Performance(
            id: joueur.idJoueur,
            nom: joueur.nomJoueur,
            type: PerformanceType.but,
            nombre: but,
          ),
        if (passe > 0)
          Performance(
            id: joueur.idJoueur,
            nom: joueur.nomJoueur,
            type: PerformanceType.passe,
            nombre: passe,
          )
      ]));
    }

    return performances;
  }

  static List<EventStatistique> getJoueurStatistique(Joueur joueur,
      {required List<Event> events}) {
    events =
        events.where((element) => element.idJoueur == joueur.idJoueur).toList();
    List<Event> jaunes = events
        .whereType<CardEvent>()
        .where((element) => !element.isRed)
        .toList();

    List<Event> rouges = events
        .whereType<CardEvent>()
        .where((element) => element.isRed)
        .toList();
    List<Event> buts = events
        .whereType<GoalEvent>()
        .where((element) => element.propre)
        .toList();
    return [
      EventStatistique(
          nom: joueur.nomJoueur,
          nombre: buts.length,
          id: joueur.idJoueur,
          type: EventType.but),
      EventStatistique(
          nom: joueur.nomJoueur,
          nombre: jaunes.length,
          id: joueur.idJoueur,
          type: EventType.jaune),
      EventStatistique(
          nom: joueur.nomJoueur,
          nombre: rouges.length,
          id: joueur.idJoueur,
          type: EventType.rouge),
    ];
  }

  static List<GameEventsStatistique> getJoueurEventsStatistique(Joueur joueur,
      {required List<Event> events, required List<Game> games}) {
    List<GameEventsStatistique> statistiques = [];
    events =
        events.where((element) => element.idJoueur == joueur.idJoueur).toList();
    List<Event> jaunes = events
        .whereType<CardEvent>()
        .where((element) => !element.isRed)
        .toList();
    List<String> idj = jaunes.map((e) => e.idGame).toSet().toList();
    for (var id in idj) {
      int nbr = events
          .whereType<CardEvent>()
          .where((element) => !element.isRed && element.idGame == id)
          .toList()
          .length;
      ;
      Game game = games.singleWhere((element) => element.idGame == id);
      statistiques.add(GameEventsStatistique(
          nom: joueur.nomJoueur,
          nombre: nbr,
          id: joueur.idJoueur,
          game: game,
          type: EventType.jaune));
    }

    List<Event> rouges = events
        .whereType<CardEvent>()
        .where((element) => element.isRed)
        .toList();
    List<String> idr = rouges.map((e) => e.idGame).toSet().toList();
    for (var id in idr) {
      int nbr = events
          .whereType<CardEvent>()
          .where((element) => element.isRed && element.idGame == id)
          .toList()
          .length;

      Game game = games.singleWhere((element) => element.idGame == id);
      statistiques.add(GameEventsStatistique(
          nom: joueur.nomJoueur,
          nombre: nbr,
          id: joueur.idJoueur,
          game: game,
          type: EventType.rouge));
    }
    List<Event> buts = events
        .whereType<GoalEvent>()
        .where((element) => element.propre)
        .toList();
    List<String> idb = buts.map((e) => e.idGame).toSet().toList();
    for (var id in idb) {
      int nbr = events
          .whereType<GoalEvent>()
          .where((element) => element.propre && element.idGame == id)
          .toList()
          .length;

      Game game = games.singleWhere((element) => element.idGame == id);
      statistiques.add(GameEventsStatistique(
          nom: joueur.nomJoueur,
          nombre: nbr,
          id: joueur.idJoueur,
          game: game,
          type: EventType.but));
    }
    return statistiques;
  }
}
