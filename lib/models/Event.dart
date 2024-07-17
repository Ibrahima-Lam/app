import 'package:app/core/enums/event_type_enum.dart';
import 'package:app/models/game.dart';

abstract class Event {
  String type;
  String? imageUrl;
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
      required this.imageUrl,
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
    super.imageUrl,
  });

  factory GoalEvent.fromJson(Map<String, dynamic> json) {
    return GoalEvent(
      idJoueur: json['idJoueur'].toString(),
      nom: json['nomJoueur'].toString(),
      idParticipant: json['idParticipant'].toString(),
      idGame: json['idGame'].toString(),
      idEvent: 'G' + json['idBut'].toString(),
      minute: (json['minute'] ?? '').toString(),
      imageUrl: '',
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
        imageUrl: '',
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
      super.nomTarget,
      super.imageUrl});

  factory CardEvent.fromJson(Map<String, dynamic> json) {
    return CardEvent(
      idJoueur: json['idJoueur'].toString(),
      isRed: json['codeSanction'] != 'jaune',
      minute: (json['minute'] ?? '').toString(),
      nom: json['nomJoueur'].toString(),
      idParticipant: json['idParticipant'].toString(),
      idGame: json['idGame'].toString(),
      idEvent: 'C' + json['idSanctionner'].toString(),
      imageUrl: '',
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
        imageUrl: '',
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
      super.nomTarget,
      super.imageUrl});

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
        imageUrl: '',
      );
}

class EventStatistique {
  String id;
  String? imageUrl;
  String nom;
  int nombre;
  EventType? type;
  EventStatistique(
      {required this.nom,
      required this.nombre,
      required this.id,
      this.type,
      this.imageUrl});
}

class GameEventsStatistique {
  String id;
  String? imageUrl;
  String nom;
  Game game;
  int nombre;
  EventType? type;
  GameEventsStatistique({
    required this.nom,
    required this.nombre,
    required this.id,
    this.type,
    this.imageUrl,
    required this.game,
  });
}
