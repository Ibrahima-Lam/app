import 'package:app/core/enums/competition_type.dart';
import 'package:app/models/searchable.dart';

class Competition implements Searchable {
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
    };
  }
}
