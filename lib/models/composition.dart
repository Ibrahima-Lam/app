abstract class Composition {
  String idGame;
  String nom;

  Composition({
    required this.idGame,
    required this.nom,
  });
}

class ArbitreComposition extends Composition {
  String role;
  ArbitreComposition(
      {required this.role, required super.idGame, required super.nom});
}

abstract class EquipeComposition extends Composition {
  int jaune;
  int rouge;
  String idParticipant;
  EquipeComposition(
      {required this.idParticipant,
      required super.nom,
      required super.idGame,
      required this.jaune,
      required this.rouge});
}

class StaffComposition extends EquipeComposition {
  StaffComposition(
      {required super.idParticipant,
      required super.nom,
      required super.idGame,
      required super.jaune,
      required super.rouge});
}

class CoachCompostition extends StaffComposition {
  CoachCompostition(
      {required super.idParticipant,
      required super.nom,
      required super.idGame,
      required super.jaune,
      required super.rouge});
}

class JoueurComposition extends EquipeComposition {
  String idJoueur;
  int numero;
  double left;
  double top;
  bool isIn;
  JoueurComposition? entrant;
  JoueurComposition? sortant;
  int? tempsEntrants;
  int? tempsSortant;
  int but;
  bool isCapitaine;

  JoueurComposition({
    required this.idJoueur,
    required this.numero,
    required this.isIn,
    required this.left,
    required this.top,
    this.entrant,
    this.tempsSortant,
    this.sortant,
    this.tempsEntrants,
    this.but = 0,
    this.isCapitaine = false,
    required super.nom,
    required super.idParticipant,
    required super.idGame,
    super.jaune = 0,
    super.rouge = 0,
  });

  JoueurComposition copyWith({
    String? idJoueur,
    String? idGame,
    String? idParticipant,
    String? nom,
    int? numero,
    double? left,
    double? top,
    bool? isIn,
    JoueurComposition? entrant,
    JoueurComposition? sortant,
    int? tempsEntrants,
    int? tempsSortant,
    int? jaune,
    int? rouge,
    int? but,
    bool? isCapitaine,
    bool? isChanged,
  }) {
    return JoueurComposition(
      idJoueur: idJoueur ?? this.idJoueur,
      numero: numero ?? this.numero,
      isIn: isIn ?? this.isIn,
      left: left ?? this.left,
      top: top ?? this.top,
      nom: nom ?? this.nom,
      jaune: jaune ?? this.jaune,
      rouge: rouge ?? this.rouge,
      but: but ?? this.but,
      isCapitaine: isCapitaine ?? this.isCapitaine,
      idParticipant: idParticipant ?? this.idParticipant,
      idGame: idGame ?? this.idGame,
      entrant: entrant ?? this.entrant,
      tempsSortant: tempsSortant ?? this.tempsSortant,
      sortant: sortant ?? this.sortant,
      tempsEntrants: tempsEntrants ?? this.tempsEntrants,
    );
  }
}
