class Niveau {
  final String codeNiveau;
  final String nomNiveau;
  final String typeNiveau;
  final String ordreNiveau;

  const Niveau({
    required this.codeNiveau,
    required this.nomNiveau,
    required this.typeNiveau,
    required this.ordreNiveau,
  });
  factory Niveau.fromJson(Map<String, dynamic> json) {
    return Niveau(
      codeNiveau: json['codeNiveau'],
      nomNiveau: json['nomNiveau'],
      typeNiveau: json['typeNiveau'],
      ordreNiveau: json['ordreNiveau'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codeNiveau': codeNiveau,
      'nomNiveau': nomNiveau,
      'typeNiveau': typeNiveau,
      'ordreNiveau': ordreNiveau,
    };
  }
}
