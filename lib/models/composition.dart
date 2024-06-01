abstract class Composition {
  String idComposition;
  String idGame;
  String nom;

  Composition({
    required this.idGame,
    required this.nom,
    required this.idComposition,
  });
}

class ArbitreComposition extends Composition {
  String role;
  ArbitreComposition(
      {required this.role,
      required super.idGame,
      required super.nom,
      required super.idComposition});
  ArbitreComposition copyWith({
    String? nom,
    String? idGame,
    String? role,
    String? idComposition,
  }) =>
      ArbitreComposition(
        idComposition: idComposition ?? this.idComposition,
        nom: nom ?? this.nom,
        idGame: idGame ?? this.idGame,
        role: role ?? this.role,
      );
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
      required this.rouge,
      required super.idComposition});
}

class StaffComposition extends EquipeComposition {
  StaffComposition(
      {required super.idParticipant,
      required super.nom,
      required super.idGame,
      required super.jaune,
      required super.rouge,
      required super.idComposition});
}

class CoachComposition extends StaffComposition {
  String idCoach;
  CoachComposition(
      {required this.idCoach,
      required super.idParticipant,
      required super.nom,
      required super.idGame,
      required super.jaune,
      required super.rouge,
      required super.idComposition});
  CoachComposition copyWith({
    String? nom,
    String? idGame,
    String? idCoach,
    String? idParticipant,
    int? jaune,
    int? rouge,
    String? idComposition,
  }) =>
      CoachComposition(
        idCoach: idCoach ?? this.idCoach,
        nom: nom ?? this.nom,
        idGame: idGame ?? this.idGame,
        idParticipant: idParticipant ?? this.idParticipant,
        jaune: jaune ?? this.jaune,
        rouge: rouge ?? this.rouge,
        idComposition: idComposition ?? this.idComposition,
      );
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
    required super.idComposition,
  });

  JoueurComposition copyWith(
      {String? idJoueur,
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
      String? idComposition}) {
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
      idComposition: idComposition ?? this.idComposition,
    );
  }
}
