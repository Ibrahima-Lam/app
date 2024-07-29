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
      {required String idGame,
      required String idParticipant,
      bool create = true}) {
    List<JoueurComposition> titulaires =
        compositions.whereType<JoueurComposition>().toList();

    titulaires = titulaires.where((element) {
      return element.isIn &&
          element.idParticipant == idParticipant &&
          element.idGame == idGame;
    }).toList();
    if (!create && titulaires.isEmpty) return [];

    if (titulaires.isEmpty) {
      titulaires = kStrategie433.map((e) {
        return e.copyWith(
          idGame: idGame,
          idParticipant: idParticipant,
          idJoueur: 'G${idGame}P${idParticipant}T${kStrategie433.indexWhere(
            (element) => element.nom == e.nom,
          )}',
          idComposition:
              'G${idGame}P${idParticipant}T${kStrategie433.indexWhere(
            (element) => element.nom == e.nom,
          )}',
        );
      }).toList();
    }
    return titulaires;
  }

  List<JoueurComposition> getRempl(
      {required String idGame,
      required String idParticipant,
      bool create = true}) {
    List<JoueurComposition> rempls =
        compositions.whereType<JoueurComposition>().toList();
    rempls = rempls
        .where((element) =>
            !element.isIn &&
            element.idParticipant == idParticipant &&
            element.idGame == idGame)
        .toList();
    if (!create && rempls.isEmpty) return [];
    if (rempls.isEmpty) {
      rempls = kRempl.map((e) {
        return e.copyWith(
            isIn: false,
            idGame: idGame,
            idParticipant: idParticipant,
            idJoueur: 'G${idGame}P${idParticipant}R${kRempl.indexWhere(
              (element) => element.nom == e.nom,
            )}',
            idComposition: 'G${idGame}P${idParticipant}R${kRempl.indexWhere(
              (element) => element.nom == e.nom,
            )}');
      }).toList();
    }
    return rempls;
  }

// Todo
  List<ArbitreComposition> getArbitres() {
    List<ArbitreComposition> arbitres =
        compositions.whereType<ArbitreComposition>().toList();

    return arbitres;
  }

  List<ArbitreComposition> getArbitresBygame(
      {required String idGame, bool create = true}) {
    List<ArbitreComposition> arbitres = compositions
        .whereType<ArbitreComposition>()
        .where(
          (element) => element.idGame == idGame,
        )
        .toList();
    if (!create && arbitres.isEmpty) return [];
    if (arbitres.isEmpty) {
      arbitres = kArbitres
          .map((e) => e.copyWith(
              idGame: idGame,
              idComposition: 'G${idGame}A${arbitres.indexWhere(
                (element) => element.nom == e.nom,
              )}'))
          .toList();
    }
    return arbitres;
  }

  // Todo
  List<CoachComposition> getCoachs() {
    List<CoachComposition> coaches =
        compositions.whereType<CoachComposition>().toList();

    return coaches;
  }

  CoachComposition getCoach(
      {required String idGame, required String idParticipant}) {
    final List<CoachComposition> coaches =
        compositions.whereType<CoachComposition>().toList();
    late CoachComposition coach = coaches.firstWhere(
        (element) => element.idParticipant == idParticipant,
        orElse: (() => kCoach.copyWith(
            idParticipant: idParticipant,
            idComposition: 'G${idGame}P${idParticipant}}')));
    return coach;
  }

  JoueurComposition getJoueurComposition({
    String? idComposition,
    required String idGame,
    required String idParticipant,
    required String idJoueur,
  }) {
    try {
      return compositions.whereType<JoueurComposition>().singleWhere(
            (element) => element.idJoueur == idJoueur,
          );
    } catch (e) {
      return compositions.whereType<JoueurComposition>().singleWhere(
            (element) => element.idComposition == idComposition,
            orElse: () => kRemplComposition.copyWith(
              idComposition: idComposition,
              idGame: idGame,
              idParticipant: idParticipant,
            ),
          );
    }
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
  bool cancelChange(JoueurComposition composition, bool isHome) {
    if (isHome) {
      int index = homeOutside
          .indexWhere((element) => element.idJoueur == composition.idJoueur);
      if (index >= 0) {
        if (homeOutside[index].sortant != null) {
          String? id = homeOutside[index].sortant?.idJoueur;
          homeOutside[index].sortant = null;
          if (id != null) {
            int i = homeInside.indexWhere((element) => element.idJoueur == id);

            if (i >= 0) homeInside[i].entrant = null;
          }
        }
      }
    } else {
      int index = awayOutside
          .indexWhere((element) => element.idJoueur == composition.idJoueur);
      if (index >= 0) {
        if (awayOutside[index].sortant != null) {
          String? id = awayOutside[index].sortant?.idJoueur;
          awayOutside[index].sortant = null;
          if (id != null) {
            int i = awayInside.indexWhere((element) => element.idJoueur == id);
            if (i >= 0) awayInside[i].entrant = null;
          }
        }
      }
    }
    return true;
  }

  bool removeArbitreComposition(String id) {
    arbitres.removeWhere((element) => element.idComposition == id);
    return true;
  }

  bool removeRemplComposition(String id, bool isHome) {
    if (isHome)
      homeOutside.removeWhere((element) => element.idComposition == id);
    if (!isHome)
      awayOutside.removeWhere((element) => element.idComposition == id);
    return true;
  }

  void changeHome(JoueurComposition sortant, JoueurComposition entrant) {
    final int sortantIndex = homeInside
        .indexWhere((element) => element.idJoueur == sortant.idJoueur);
    final int entrantIndex = homeOutside
        .indexWhere((element) => element.idJoueur == entrant.idJoueur);

    homeInside[sortantIndex].entrant = entrant.copyWith();
    homeOutside[entrantIndex].sortant = sortant.copyWith();
  }

  void changeAway(JoueurComposition sortant, JoueurComposition entrant) {
    final int sortantIndex = awayInside
        .indexWhere((element) => element.idJoueur == sortant.idJoueur);
    final int entrantIndex = awayOutside
        .indexWhere((element) => element.idJoueur == entrant.idJoueur);

    awayInside[sortantIndex].entrant = entrant.copyWith();
    awayOutside[entrantIndex].sortant = sortant.copyWith();
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
