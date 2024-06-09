import 'package:app/models/searchable.dart';

class Participant implements Searchable {
  String idParticipant;
  String? idEquipe;
  String? idEdition;
  String nomEquipe;
  String? libelleEquipe;
  String? localiteEquipe;
  String? codeEdition;
  String? anneeEdition;
  String? nomEdition;
  String? codeCompetition;
  String? nomCompetition;
  String? localiteCompetition;
  Participant({
    required this.idParticipant,
    this.idEquipe,
    this.idEdition,
    required this.nomEquipe,
    this.libelleEquipe,
    this.localiteEquipe,
    this.codeEdition,
    this.anneeEdition,
    this.nomEdition,
    this.codeCompetition,
    this.nomCompetition,
    this.localiteCompetition,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
        idParticipant: json["idParticipant"].toString(),
        idEquipe: json["idEquipe"].toString(),
        idEdition: json["idEdition"],
        nomEquipe: json["nomEquipe"],
        libelleEquipe: json["libelleEquipe"],
        localiteEquipe: json["localiteEquipe"],
        codeEdition: json["codeEdition"],
        anneeEdition: json["anneeEdition"],
        nomEdition: json["nomEdition"],
        codeCompetition: json["codeCompetition"],
        nomCompetition: json["nomCompetition"],
        localiteCompetition: json["localiteCompetition"]);
  }
}
