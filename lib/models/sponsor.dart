class Sponsor {
  String idSponsor;
  String imageUrl;
  String nom;
  String? description;
  String? date;
  String? idEdition;
  String? idGame;
  String? idParticipant;
  String? idJoueur;
  String? idArbitre;
  String? idCoach;
  Sponsor(
      {required this.idSponsor,
      required this.imageUrl,
      required this.nom,
      this.description,
      this.date,
      this.idEdition,
      this.idGame,
      this.idParticipant,
      this.idJoueur,
      this.idArbitre,
      this.idCoach});
  factory Sponsor.fromJson(Map<String, dynamic> json) => Sponsor(
        idSponsor: json['idSponsor'],
        imageUrl: json['imageUrl'],
        nom: json['nom'] ?? '',
        description: json['description'],
        idEdition: json['idEdition'],
        idGame: json['idGame'],
        idParticipant: json['idParticipant'],
        idJoueur: json['idJoueur'],
        idArbitre: json['idArbitre'],
        idCoach: json['idCoach'],
        date: json['date'],
      );
  Map<String, dynamic> toJson() => {
        'idSponsor': idSponsor,
        'imageUrl': imageUrl,
        'description': description,
        'idEdition': idEdition,
        'idGame': idGame,
        'idParticipant': idParticipant,
        'idJoueur': idJoueur,
        'idArbitre': idArbitre,
        'idCoach': idCoach,
        'date': date,
        'nom': nom,
      };
}
