class CategorieParams {
  String? idEdition;
  String? idGame;
  String? idParticipant;
  String? idParticipant2;
  String? idJoueur;
  String? idArbitre;
  String? idCoach;
  CategorieParams({
    this.idEdition,
    this.idGame,
    this.idParticipant,
    this.idParticipant2,
    this.idJoueur,
    this.idArbitre,
    this.idCoach,
  });

  bool get isNull {
    if ((
      idEdition,
      idGame,
      idParticipant,
      idParticipant2,
      idJoueur,
      idArbitre,
      idCoach,
    )
        case (null, null, null, null, null, null, null)) return true;
    return false;
  }
}
