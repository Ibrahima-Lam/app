import 'package:fscore/core/class/populaire.dart';
import 'package:fscore/core/enums/competition_type.dart';
import 'package:fscore/models/searchable.dart';

class Competition implements Searchable, Populaire {
  String codeCompetition;
  String nomCompetition;
  String? localiteCompetition;
  String codeEdition;
  String? nomEdition;
  String? anneeEdition;
  String? imageUrl;
  CompetitionTypeClass type;
  Competition({
    required this.codeCompetition,
    required this.nomCompetition,
    this.localiteCompetition,
    required this.codeEdition,
    this.nomEdition,
    this.anneeEdition,
    this.type = const CompetitionTypeClass('coupe'),
    this.imageUrl,
    this.rating,
  });

  bool get hasClassement {
    if (type.type case (CompetitionType.coupe || CompetitionType.championnat))
      return true;
    return false;
  }

  factory Competition.fromJson(Map<String, dynamic> json) {
    return Competition(
      codeCompetition: json['codeCompetition'],
      nomCompetition: json['nomCompetition'],
      localiteCompetition: json['localiteCompetition'],
      codeEdition: json['codeEdition'],
      nomEdition: json['nomEdition'],
      anneeEdition: json['anneeEdition'],
      type: CompetitionTypeClass(json['type'] ?? 'coupe'),
      imageUrl: json['imageUrl'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codeCompetition': codeCompetition,
      'nomCompetition': nomCompetition,
      'localiteCompetition': localiteCompetition,
      'codeEdition': codeEdition,
      'nomEdition': nomEdition,
      'anneeEdition': anneeEdition,
      'rating': rating,
      'imageUrl': imageUrl,
      'type': type.text,
    };
  }

  @override
  num? rating;
}
