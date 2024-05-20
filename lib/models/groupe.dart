class Groupe {
  String? idGroupe;
  String? nomGroupe;
  String? codeEdition;
  String? codePhase;
  String? nomPhase;
  String? typePhase;

  Groupe({
    this.idGroupe,
    this.nomGroupe,
    this.codeEdition,
    this.codePhase,
    this.nomPhase,
    this.typePhase,
  });

  factory Groupe.fromJson(Map<String, dynamic> json) {
    return Groupe(
        idGroupe: json["idGroupe"].toString(),
        nomGroupe: json["nomGroupe"],
        codePhase: json["codePhase"],
        codeEdition: json["codeEdition"],
        nomPhase: json["nomPhase"],
        typePhase: json["typePhase"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "idGroupe": idGroupe,
      "nomGroupe": nomGroupe,
      "codePhase": codePhase,
      "codeEdition": codeEdition,
      "nomPhase": nomPhase,
      "typePhase": typePhase
    };
  }
}
