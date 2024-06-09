import 'package:app/core/enums/event_type_enum.dart';

abstract class Event {
  String type;
  String idEvent;
  String idJoueur;
  String nom;
  String? minute;
  String idParticipant;
  String idGame;
  String? idTarget;
  String? nomTarget;

  Event(
      {required this.type,
      required this.idJoueur,
      required this.idEvent,
      required this.idParticipant,
      required this.idGame,
      required this.nom,
      this.idTarget,
      this.nomTarget,
      this.minute});
}

class GoalEvent extends Event {
  String? idTarget;
  String? nomTarget;
  bool propre;
  GoalEvent({
    super.type = 'but',
    required super.idJoueur,
    required super.nom,
    super.minute,
    this.idTarget,
    this.nomTarget,
    this.propre = true,
    required super.idParticipant,
    required super.idGame,
    required super.idEvent,
  });

  factory GoalEvent.fromJson(Map<String, dynamic> json) {
    return GoalEvent(
      idJoueur: json['idJoueur'].toString(),
      nom: json['nomJoueur'].toString(),
      idParticipant: json['idParticipant'].toString(),
      idGame: json['idGame'].toString(),
      idEvent: 'G' + json['idBut'].toString(),
      minute: (json['minute'] ?? '').toString(),
    );
  }

  GoalEvent copyWith({
    String? type,
    String? idJoueur,
    String? minute,
    String? idTarget,
    String? nomTarget,
    bool? propre,
    String? idParticipant,
    String? idGame,
    String? idEvent,
    String? nom,
  }) =>
      GoalEvent(
        idJoueur: idJoueur ?? this.idJoueur,
        nom: nom ?? this.nom,
        idParticipant: idParticipant ?? this.idParticipant,
        idGame: idGame ?? this.idGame,
        idEvent: idEvent ?? this.idEvent,
        idTarget: idTarget ?? this.idTarget,
        nomTarget: nomTarget ?? this.nomTarget,
        minute: minute ?? this.minute,
        propre: propre ?? this.propre,
      );
}

class CardEvent extends Event {
  bool isRed;

  CardEvent(
      {this.isRed = false,
      super.type = 'carton',
      required super.idJoueur,
      required super.idEvent,
      required super.idParticipant,
      required super.idGame,
      super.minute,
      required super.nom,
      super.idTarget,
      super.nomTarget});

  factory CardEvent.fromJson(Map<String, dynamic> json) {
    return CardEvent(
      idJoueur: json['idJoueur'].toString(),
      isRed: json['codeSanction'] != 'jaune',
      minute: (json['minute'] ?? '').toString(),
      nom: json['nomJoueur'].toString(),
      idParticipant: json['idParticipant'].toString(),
      idGame: json['idGame'].toString(),
      idEvent: 'C' + json['idSanctionner'].toString(),
    );
  }

  CardEvent copyWith({
    String? type,
    String? idJoueur,
    String? minute,
    String? idTarget,
    String? nomTarget,
    String? idParticipant,
    String? idGame,
    String? idEvent,
    String? nom,
    bool? isRed,
  }) =>
      CardEvent(
        idJoueur: idJoueur ?? this.idJoueur,
        nom: nom ?? this.nom,
        idParticipant: idParticipant ?? this.idParticipant,
        idGame: idGame ?? this.idGame,
        idEvent: idEvent ?? this.idEvent,
        minute: minute ?? this.minute,
        isRed: isRed ?? this.isRed,
        idTarget: idTarget ?? this.idTarget,
        nomTarget: nomTarget ?? this.nomTarget,
      );
}

class RemplEvent extends Event {
  RemplEvent(
      {super.type = 'changement',
      required super.idJoueur,
      required super.idEvent,
      required super.idParticipant,
      required super.idGame,
      required super.nom,
      super.minute,
      super.idTarget,
      super.nomTarget});

  RemplEvent copyWith({
    String? idJoueur,
    String? minute,
    String? idTarget,
    String? nomTarget,
    String? idParticipant,
    String? idGame,
    String? idEvent,
    String? nom,
    bool? isRed,
  }) =>
      RemplEvent(
        type: 'changement',
        idJoueur: idJoueur ?? this.idJoueur,
        nom: nom ?? this.nom,
        idParticipant: idParticipant ?? this.idParticipant,
        idGame: idGame ?? this.idGame,
        idEvent: idEvent ?? this.idEvent,
        minute: minute ?? this.minute,
        idTarget: idTarget ?? this.idTarget,
        nomTarget: nomTarget ?? this.nomTarget,
      );
}

class EventStatistique {
  String id;
  String nom;
  int nombre;
  EventType? type;
  EventStatistique(
      {required this.nom, required this.nombre, required this.id, this.type});
}
