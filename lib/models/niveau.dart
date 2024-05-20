class Niveau {
  String? codeNiveau;
  String? nomNiveau;
  String? typeNiveau;

  Niveau({
    this.codeNiveau,
    this.nomNiveau,
    this.typeNiveau,
  });
  factory Niveau.fromJson(Map<String, dynamic> json) {
    return Niveau(
      codeNiveau: json['codeNiveau'],
      nomNiveau: json['nomNiveau'],
      typeNiveau: json['typeNiveau'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codeNiveau:': codeNiveau,
      'nomNiveau:': nomNiveau,
      'typeNiveau:': typeNiveau,
    };
  }
}
