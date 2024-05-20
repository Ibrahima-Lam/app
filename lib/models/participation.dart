import 'package:app/models/groupe.dart';

class Participation extends Groupe {
  int? idParticipation;
  int? idParticipant;
  int? idEquipe;
  String? idEdition;
  String? nomEquipe;
  String? libelleEquipe;
  String? localiteEquipe;
  String? anneeEdition;
  String? nomEdition;
  String? codeCompetition;
  String? nomCompetition;
  String? localiteCompetition;
  Participation({
    this.idParticipation,
    this.idParticipant,
    this.idEquipe,
    this.idEdition,
    this.nomEquipe,
    this.libelleEquipe,
    this.localiteEquipe,
    this.anneeEdition,
    this.nomEdition,
    this.codeCompetition,
    this.nomCompetition,
    this.localiteCompetition,
    super.idGroupe,
    super.nomGroupe,
    super.codeEdition,
    super.codePhase,
    super.nomPhase,
    super.typePhase,
  });

  factory Participation.fromJson(Map<String, dynamic> json) {
    return Participation(
      idParticipation: json["idParticipation"],
      idGroupe: json["idGroupe"].toString(),
      idParticipant: json["idParticipant"],
      nomGroupe: json["nomGroupe"],
      codePhase: json["codePhase"],
      codeEdition: json["codeEdition"],
      idEquipe: json["idEquipe"],
      idEdition: json["idEdition"],
      nomEquipe: json["nomEquipe"],
      libelleEquipe: json["libelleEquipe"],
      localiteEquipe: json["localiteEquipe"],
      anneeEdition: json["anneeEdition"],
      nomEdition: json["nomEdition"],
      codeCompetition: json["codeCompetition"],
      nomCompetition: json["nomCompetition"],
      localiteCompetition: json["localiteCompetition"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idParticipation": idParticipation,
      "idParticipant": idParticipant,
      "idEquipe": idEquipe,
      "idEdition": idEdition,
      "nomEquipe": nomEquipe,
      "libelleEquipe": libelleEquipe,
      "localiteEquipe": localiteEquipe,
      "anneeEdition": anneeEdition,
      "nomEdition": nomEdition,
      "codeCompetition": codeCompetition,
      "nomCompetition": nomCompetition,
      "localiteCompetition": localiteCompetition,
      "idGroupe": idGroupe,
      "nomGroupe": nomGroupe,
      "codeEdition": codeEdition,
      "codePhase": codePhase,
      "nomPhase": nomPhase,
      "typePhase": typePhase,
    };
  }
}
