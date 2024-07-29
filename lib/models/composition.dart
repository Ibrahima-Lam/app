import 'package:app/core/extension/list_extension.dart';

abstract class Composition {
  String idComposition;
  String idGame;
  String nom;
  String? imageUrl;
  Map<String, dynamic> toJson();

  Composition({
    required this.idGame,
    required this.nom,
    required this.idComposition,
    this.imageUrl,
  });
}

class ArbitreComposition extends Composition {
  String role;
  String idArbitre;
  ArbitreComposition(
      {required this.role,
      required this.idArbitre,
      required super.idGame,
      required super.nom,
      required super.idComposition,
      super.imageUrl});
  factory ArbitreComposition.fromJson(Map<String, dynamic> json) =>
      ArbitreComposition(
        idGame: json['idGame'],
        nom: json['nom'],
        idComposition: json['idComposition'],
        imageUrl: json['imageUrl'],
        role: json['role'],
        idArbitre: json['idArbitre'],
      );
  Map<String, dynamic> toJson() {
    return {
      'idGame': idGame,
      'nom': nom,
      'idComposition': idComposition,
      'imageUrl': imageUrl,
      'role': role,
      'idArbitre': idArbitre,
    };
  }

  ArbitreComposition copyWith({
    String? nom,
    String? idGame,
    String? role,
    String? idComposition,
    String? idArbitre,
    String? imageUrl,
  }) =>
      ArbitreComposition(
        idComposition: idComposition ?? this.idComposition,
        idArbitre: idArbitre ?? this.idArbitre,
        nom: nom ?? this.nom,
        idGame: idGame ?? this.idGame,
        role: role ?? this.role,
        imageUrl: imageUrl ?? this.imageUrl,
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
      required super.idComposition,
      super.imageUrl});
}

class StaffComposition extends EquipeComposition {
  StaffComposition(
      {required super.idParticipant,
      required super.nom,
      required super.idGame,
      required super.jaune,
      required super.rouge,
      required super.idComposition,
      super.imageUrl});
  factory StaffComposition.fromJson(Map<String, dynamic> json) =>
      StaffComposition(
        idGame: json['idGame'],
        idParticipant: json['idParticipant'],
        nom: json['nom'],
        idComposition: json['idComposition'],
        imageUrl: json['imageUrl'],
        jaune: json['jaune'] ?? 0,
        rouge: json['rouge'] ?? 0,
      );
  Map<String, dynamic> toJson() {
    return {
      'idGame': idGame,
      'idParticipant': idParticipant,
      'nom': nom,
      'idComposition': idComposition,
      'imageUrl': imageUrl,
      'jaune': jaune,
      'rouge': rouge,
    };
  }
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
      required super.idComposition,
      super.imageUrl});
  factory CoachComposition.fromJson(Map<String, dynamic> json) =>
      CoachComposition(
        idGame: json['idGame'],
        idParticipant: json['idParticipant'],
        nom: json['nom'],
        idComposition: json['idComposition'],
        imageUrl: json['imageUrl'],
        idCoach: json['idCoach'],
        jaune: json['jaune'] ?? 0,
        rouge: json['rouge'] ?? 0,
      );
  Map<String, dynamic> toJson() {
    return {
      'idGame': idGame,
      'idParticipant': idParticipant,
      'nom': nom,
      'idComposition': idComposition,
      'imageUrl': imageUrl,
      'idCoach': idCoach,
      'jaune': jaune,
      'rouge': rouge,
    };
  }

  CoachComposition copyWith({
    String? nom,
    String? idGame,
    String? idCoach,
    String? idParticipant,
    int? jaune,
    int? rouge,
    String? idComposition,
    String? imageUrl,
  }) =>
      CoachComposition(
        idCoach: idCoach ?? this.idCoach,
        nom: nom ?? this.nom,
        idGame: idGame ?? this.idGame,
        idParticipant: idParticipant ?? this.idParticipant,
        jaune: jaune ?? this.jaune,
        rouge: rouge ?? this.rouge,
        idComposition: idComposition ?? this.idComposition,
        imageUrl: imageUrl ?? this.imageUrl,
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
    super.imageUrl,
  });
  factory JoueurComposition.fromJson(Map<String, dynamic> json,
      {List<Map<String, dynamic>> listeComposition = const []}) {
    JoueurComposition? entrant;
    JoueurComposition? sortant;
    if (json['entrant'] != null) {
      Map<String, dynamic> e = listeComposition.singleWhereOrNull(
              (element) => element['idJoueur'] == json['entrant']) ??
          {};
      if (e.isNotEmpty) {
        entrant = JoueurComposition.fromJson(e);
      }
    }
    if (json['sortant'] != null) {
      Map<String, dynamic> s = listeComposition.singleWhereOrNull(
              (element) => element['idJoueur'] == json['sortant']) ??
          {};
      if (s.isNotEmpty) {
        sortant = JoueurComposition.fromJson(s);
      }
    }
    return JoueurComposition(
      idGame: json['idGame'],
      idParticipant: json['idParticipant'],
      nom: json['nom'],
      idComposition: json['idComposition'],
      imageUrl: json['imageUrl'],
      idJoueur: json['idJoueur'],
      numero: json['numero'] ?? 0,
      isIn: json['isIn'] ?? false,
      left: json['left'] ?? 0,
      top: json['top'] ?? 0,
      isCapitaine: json['isCapitaine'] ?? false,
      but: json['but'] ?? 0,
      jaune: json['jaune'] ?? 0,
      rouge: json['rouge'] ?? 0,
      tempsEntrants: json['tempsEntrants'] ?? 0,
      tempsSortant: json['tempsSortant'] ?? 0,
      entrant: entrant,
      sortant: sortant,
    );
  }
  toJson() {
    return {
      'idGame': idGame,
      'idParticipant': idParticipant,
      'nom': nom,
      'idComposition': idComposition,
      'imageUrl': imageUrl,
      'idJoueur': idJoueur,
      'numero': numero,
      'isIn': isIn,
      'left': left,
      'top': top,
      'isCapitaine': isCapitaine,
      'but': but,
      'jaune': jaune,
      'rouge': rouge,
      'tempsEntrants': tempsEntrants,
      'tempsSortant': tempsSortant,
      'entrant': entrant?.idJoueur,
      'sortant': sortant?.idJoueur,
    };
  }

  JoueurComposition copyWith(
      {String? idJoueur,
      String? idGame,
      String? imageUrl,
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
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
