import 'package:app/models/searchable.dart';

class Joueur implements Searchable {
  String idJoueur;
  String nomJoueur;
  String idParticipant;
  String? localiteJoueur;
  String idEquipe;
  String nomEquipe;
  String? libelleEquipe;
  String? localiteEquipe;
  String codeEdition;
  String? anneeEdition;
  String? nomEdition;
  String? codeCompetition;
  String nomCompetition;
  String? localiteCompetition;
  String? imageUrl;

  Joueur({
    required this.idJoueur,
    required this.nomJoueur,
    required this.idParticipant,
    this.localiteJoueur,
    required this.idEquipe,
    required this.nomEquipe,
    this.libelleEquipe,
    this.localiteEquipe,
    required this.codeEdition,
    this.anneeEdition,
    this.nomEdition,
    this.codeCompetition,
    required this.nomCompetition,
    this.localiteCompetition,
    this.imageUrl,
  });

  factory Joueur.fromJson(Map<String, dynamic> json) {
    return Joueur(
      idJoueur: json['idJoueur'].toString(),
      nomJoueur: json['nomJoueur'],
      idParticipant: json['idParticipant'].toString(),
      localiteJoueur: json['localiteJoueur'],
      idEquipe: json['idEquipe'].toString(),
      nomEquipe: json['nomEquipe'],
      libelleEquipe: json['libelleEquipe'],
      localiteEquipe: json['localiteEquipe'],
      codeEdition: json['codeEdition'],
      anneeEdition: json['anneeEdition'],
      nomEdition: json['nomEdition'],
      codeCompetition: json['codeCompetition'],
      nomCompetition: json['nomCompetition'],
      localiteCompetition: json['localiteCompetition'],
    );
  }
}
