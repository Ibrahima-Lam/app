class Statistique {
  String idStatistique;
  String codeStatistique;
  String nomStatistique;
  num homeStatistique;
  num awayStatistique;
  String idGame;
  int rang;

  Statistique({
    required this.idStatistique,
    required this.codeStatistique,
    required this.nomStatistique,
    required this.homeStatistique,
    required this.awayStatistique,
    required this.idGame,
    this.rang = 0,
  });

  factory Statistique.fromJson(Map<String, dynamic> json) {
    return Statistique(
      idStatistique: json['idStatistique'],
      codeStatistique: json['codeStatistique'],
      nomStatistique: json['nomStatistique'],
      homeStatistique: json['homeStatistique'],
      awayStatistique: json['awayStatistique'],
      idGame: json['idGame'],
      rang: json['rang'],
    );
  }
  Map<String, dynamic> toJson() => {
        'idStatistique': idStatistique,
        'codeStatistique': codeStatistique,
        'nomStatistique': nomStatistique,
        'homeStatistique': homeStatistique,
        'awayStatistique': awayStatistique,
        'idGame': idGame,
        'rang': rang,
      };

  Statistique copyWith({
    String? idStatistique,
    String? codeStatistique,
    String? nomStatistique,
    num? homeStatistique,
    num? awayStatistique,
    String? idGame,
    int? rang,
  }) =>
      Statistique(
        idStatistique: idStatistique ?? this.idStatistique,
        codeStatistique: codeStatistique ?? this.codeStatistique,
        nomStatistique: nomStatistique ?? this.nomStatistique,
        homeStatistique: homeStatistique ?? this.homeStatistique,
        awayStatistique: awayStatistique ?? this.awayStatistique,
        idGame: idGame ?? this.idGame,
        rang: rang ?? this.rang,
      );
}
