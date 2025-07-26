import 'package:fscore/models/groupe.dart';
import 'package:fscore/models/participant.dart';

class Participation {
  String idParticipation;
  String idParticipant;
  String idGroupe;
  Groupe groupe;
  Participant participant;

  Participation({
    required this.idParticipation,
    required this.idParticipant,
    required this.idGroupe,
    required this.groupe,
    required this.participant,
  });

  factory Participation.fromJson(
      Map<String, dynamic> json, Participant participant, Groupe groupe) {
    return Participation(
      idParticipation: json["idParticipation"].toString(),
      idParticipant: json["idParticipant"].toString(),
      idGroupe: json["idGroupe"].toString(),
      groupe: groupe,
      participant: participant,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idParticipation": idParticipation,
      "idParticipant": idParticipant,
      "idGroupe": idGroupe,
    };
  }
}
