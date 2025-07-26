import 'package:fscore/core/class/populaire.dart';
import 'package:fscore/models/searchable.dart';

class Participant implements Searchable, Populaire {
  String idParticipant;
  String? idEquipe;
  String nomEquipe;
  String? libelleEquipe;
  String? localiteEquipe;
  String codeEdition;
  String? imageUrl;

  @override
  num? rating;
  Participant({
    required this.idParticipant,
    this.idEquipe,
    required this.nomEquipe,
    this.libelleEquipe,
    this.localiteEquipe,
    required this.codeEdition,
    this.imageUrl,
    this.rating,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      idParticipant: json["idParticipant"].toString(),
      idEquipe: json["idEquipe"].toString(),
      nomEquipe: json["nomEquipe"],
      libelleEquipe: json["libelleEquipe"],
      localiteEquipe: json["localiteEquipe"],
      codeEdition: json["codeEdition"],
      rating: json["rating"],
      imageUrl: json["imageUrl"],
    );
  }
  Map<String, dynamic> toJson() => {
        'idParticipant': idParticipant,
        'idEquipe': idEquipe,
        'nomEquipe': nomEquipe,
        'libelleEquipe': libelleEquipe,
        'localiteEquipe': localiteEquipe,
        'codeEdition': codeEdition,
        'rating': rating,
        'imageUrl': imageUrl,
      };
}
