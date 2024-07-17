import 'package:app/models/phase.dart';

class Groupe {
  String idGroupe;
  String nomGroupe;
  String codeEdition;
  String codePhase;
  Phase phase;

  Groupe(
      {required this.idGroupe,
      required this.nomGroupe,
      required this.codeEdition,
      required this.codePhase,
      required this.phase});

  factory Groupe.fromJson(Map<String, dynamic> json, Phase phase) {
    return Groupe(
      idGroupe: json["idGroupe"].toString(),
      nomGroupe: json["nomGroupe"],
      codePhase: json["codePhase"],
      codeEdition: json["codeEdition"],
      phase: phase,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idGroupe": idGroupe,
      "nomGroupe": nomGroupe,
      "codePhase": codePhase,
      "codeEdition": codeEdition,
    };
  }
}
