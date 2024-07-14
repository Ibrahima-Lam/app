import 'package:app/models/searchable.dart';

class Participant implements Searchable {
  String idParticipant;
  String? idEquipe;
  String nomEquipe;
  String? libelleEquipe;
  String? localiteEquipe;
  String codeEdition;
  String? imageUrl;
  Participant({
    required this.idParticipant,
    this.idEquipe,
    required this.nomEquipe,
    this.libelleEquipe,
    this.localiteEquipe,
    required this.codeEdition,
    this.imageUrl,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      idParticipant: json["idParticipant"].toString(),
      idEquipe: json["idEquipe"].toString(),
      nomEquipe: json["nomEquipe"],
      libelleEquipe: json["libelleEquipe"],
      localiteEquipe: json["localiteEquipe"],
      codeEdition: json["codeEdition"],
    );
  }
}
