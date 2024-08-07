import 'package:app/core/class/populaire.dart';
import 'package:app/models/participant.dart';
import 'package:app/models/searchable.dart';
import 'package:flutter/material.dart';

class Joueur implements Searchable, Populaire {
  String idJoueur;
  String nomJoueur;
  String idParticipant;
  String? localiteJoueur;
  String? imageUrl;
  num? poids;
  num? taille;
  num? vitesse;
  String? dateNaissance;
  String? pseudo;
  Participant participant;
  int? numero;

  Joueur({
    required this.idJoueur,
    required this.nomJoueur,
    required this.idParticipant,
    this.localiteJoueur,
    required this.participant,
    this.imageUrl,
    this.dateNaissance,
    this.poids,
    this.taille,
    this.vitesse,
    this.pseudo,
    this.rating,
    this.numero,
  });
  int? get age {
    if (dateNaissance != null) {
      try {
        DateTime now = DateTime.now();
        DateTime naiss = DateTime.parse(dateNaissance!);
        return DateTimeRange(start: naiss, end: now).duration.inHours ~/
            (24 * 365);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  factory Joueur.fromJson(Map<String, dynamic> json, Participant participant) {
    return Joueur(
        idJoueur: json['idJoueur'].toString(),
        nomJoueur: json['nomJoueur'],
        idParticipant: json['idParticipant'].toString(),
        localiteJoueur: json['localiteJoueur'],
        vitesse: json['vitesse'],
        poids: json['poids'],
        taille: json['taille'],
        dateNaissance: json['dateNaissance'],
        pseudo: json['pseudo'],
        rating: json['rating'],
        numero: json['numero'],
        imageUrl: json['imageUrl'],
        participant: participant);
  }
  Map<String, dynamic> toJson() {
    return {
      'idJoueur': idJoueur,
      'nomJoueur': nomJoueur,
      'idParticipant': idParticipant,
      'localiteJoueur': localiteJoueur,
      'imageUrl': imageUrl,
      'dateNaissance': dateNaissance,
      'poids': poids,
      'taille': taille,
      'vitesse': vitesse,
      'pseudo': pseudo,
      'rating': rating,
      'numero': numero,
    };
  }

  @override
  num? rating;
}
