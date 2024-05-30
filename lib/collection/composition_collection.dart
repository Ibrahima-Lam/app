import 'package:app/collection/collection.dart';
import 'package:app/core/constants/arbitre/kArbitre.dart';
import 'package:app/core/constants/coatch/kCoatch.dart';
import 'package:app/core/constants/strategie/rempl.dart';
import 'package:app/core/constants/strategie/strategie_433.dart';
import 'package:app/core/constants/strategie/strategie_442.dart';
import 'package:app/models/composition.dart';
import 'package:app/models/game.dart';

class CompositionCollection implements Collection {
  List<Composition> _compositions;

  CompositionCollection(this._compositions);

  List<Composition> get compositions => _compositions;
  void set compositions(List<Composition> val) => _compositions = val;

  @override
  getElementAt(String id) {}

  bool get isEmpty => _compositions.isEmpty;

  @override
  bool get isNotEmpty => _compositions.isNotEmpty;

  List<Composition> getCompositionsBy(
      {String? idGame, String? idEquipe, String? idJoueur}) {
    List<Composition> compos = _compositions;
    if (idGame != null) {
      compos = compos.where((element) => element.idGame == idGame).toList();
    }
    if (idEquipe != null) {
      compos = compos
          .where((element) =>
              (element as JoueurComposition).idParticipant == idEquipe)
          .toList();
    }
    if (idJoueur != null) {
      compos = compos
          .where(
              (element) => (element as JoueurComposition).idJoueur == idJoueur)
          .toList();
    }
    return compos;
  }

  List<JoueurComposition> getTitulaire(
      {required String idGame, required String idParticipant}) {
    List<JoueurComposition> titulaires =
        compositions.whereType<JoueurComposition>().toList();

    titulaires = titulaires.where((element) {
      return element.isIn &&
          element.idParticipant == idParticipant &&
          element.idGame == idGame;
    }).toList();

    if (titulaires.isEmpty) {
      titulaires = kStrategie433.map((e) {
        return e.copyWith(
            idGame: idGame,
            idParticipant: idParticipant,
            idJoueur: 'G${idGame}P${idParticipant}J${kStrategie433.indexWhere(
              (element) => element.nom == e.nom,
            )}');
      }).toList();
    }
    return titulaires;
  }

  List<JoueurComposition> getRempl(
      {required String idGame, required String idParticipant}) {
    List<JoueurComposition> rempls =
        compositions.whereType<JoueurComposition>().toList();
    rempls = rempls
        .where((element) =>
            !element.isIn &&
            element.idParticipant == idParticipant &&
            element.idGame == idGame)
        .toList();

    if (rempls.isEmpty) {
      rempls = kRempl.map((e) {
        return e.copyWith(
            isIn: false,
            idGame: idGame,
            idParticipant: idParticipant,
            idJoueur: 'G${idGame}P${idParticipant}J${kRempl.indexWhere(
              (element) => element.nom == e.nom,
            )}');
      }).toList();
    }
    return rempls;
  }

  List<ArbitreComposition> getArbitres({required String idGame}) {
    List<ArbitreComposition> arbitres =
        compositions.whereType<ArbitreComposition>().toList();
    if (arbitres.isEmpty) {
      arbitres = kArbitres.map((e) => e.copyWith(idGame: idGame)).toList();
    }
    return arbitres;
  }

  CoachComposition getCoach(
      {required String idGame, required String idParticipant}) {
    final List<CoachComposition> coaches =
        compositions.whereType<CoachComposition>().toList();
    late CoachComposition coach = coaches.firstWhere(
        (element) => element.idParticipant == idParticipant,
        orElse: (() => kCoach.copyWith(idParticipant: idParticipant)));
    return coach;
  }
}

class CompositionSousCollection {
  final Game game;
  List<JoueurComposition> homeInside;
  List<JoueurComposition> awayInside;
  List<JoueurComposition> homeOutside;
  List<JoueurComposition> awayOutside;
  List<ArbitreComposition> arbitres;
  CoachComposition homeCoatch;
  CoachComposition awayCoatch;
  CompositionSousCollection({
    required this.homeInside,
    required this.homeOutside,
    required this.awayInside,
    required this.awayOutside,
    required this.homeCoatch,
    required this.awayCoatch,
    required this.arbitres,
    required this.game,
  });

  void changeHome(JoueurComposition sortant, JoueurComposition entrant) {
    final int sortantIndex = homeInside
        .indexWhere((element) => element.idJoueur == sortant.idJoueur);
    final int entrantIndex = homeOutside
        .indexWhere((element) => element.idJoueur == entrant.idJoueur);
    /* final JoueurComposition s = sortant.copyWith(
      tempsSortant: 0,
    );
    final JoueurComposition e = entrant.copyWith(
      tempsEntrants: 0,
    ); */

    homeInside[sortantIndex].entrant = entrant;
    homeOutside[entrantIndex].sortant = sortant;
  }

  void changeAway(JoueurComposition sortant, JoueurComposition entrant) {
    final int sortantIndex = awayInside
        .indexWhere((element) => element.idJoueur == sortant.idJoueur);
    final int entrantIndex = awayOutside
        .indexWhere((element) => element.idJoueur == entrant.idJoueur);
    /*  final JoueurComposition s = sortant.copyWith(
      tempsSortant: 0,
    );
    final JoueurComposition e = entrant.copyWith(
      tempsEntrants: 0,
    ); */
    awayInside[sortantIndex].entrant = entrant;
    awayOutside[entrantIndex].sortant = sortant;
  }

  void homeTo433() {
    for (int i = 0; i < kStrategie433.length; i++) {
      homeInside[i].left = kStrategie433[i].left;
      homeInside[i].top = kStrategie433[i].top;
    }
  }

  void awayTo433() {
    for (int i = 0; i < kStrategie433.length; i++) {
      awayInside[i].left = kStrategie433[i].left;
      awayInside[i].top = kStrategie433[i].top;
    }
  }

  void homeTo442() {
    for (int i = 0; i < kStrategie442.length; i++) {
      homeInside[i].left = kStrategie442[i].left;
      homeInside[i].top = kStrategie442[i].top;
    }
  }

  void awayTo442() {
    for (int i = 0; i < kStrategie442.length; i++) {
      awayInside[i].left = kStrategie442[i].left;
      awayInside[i].top = kStrategie442[i].top;
    }
  }
}
