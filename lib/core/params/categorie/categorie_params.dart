class CategorieParams {
  String? idEdition;
  String? idGame;
  String? idPartcipant;
  String? idPartcipant2;
  String? idJoueur;
  String? idArbitre;
  String? idCoach;
  CategorieParams({
    this.idEdition,
    this.idGame,
    this.idPartcipant,
    this.idPartcipant2,
    this.idJoueur,
    this.idArbitre,
    this.idCoach,
  });

  bool get isNull {
    if ((
      idEdition,
      idGame,
      idPartcipant,
      idPartcipant2,
      idJoueur,
      idArbitre,
      idCoach,
    )
        case (null, null, null, null, null, null, null)) return true;
    return false;
  }
}
