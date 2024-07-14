class Phase {
  String codePhase;
  String nomPhase;
  String typePhase;
  String ordrePhase;

  Phase({
    required this.codePhase,
    required this.nomPhase,
    required this.typePhase,
    required this.ordrePhase,
  });
  factory Phase.fromJson(Map<String, dynamic> json) {
    return Phase(
      codePhase: json['codePhase'],
      nomPhase: json['nomPhase'],
      typePhase: json['typePhase'],
      ordrePhase: json['ordrePhase'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codePhase': codePhase,
      'nomPhase': nomPhase,
      'typePhase': typePhase,
      'ordrePhase': ordrePhase,
    };
  }
}
