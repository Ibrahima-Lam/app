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
