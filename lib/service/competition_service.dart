import 'package:app/models/competition.dart';

class CompetitionService {
  Future<List<Competition>> get getData async {
    await Future.delayed(const Duration(seconds: 1));

    return competitions.map((e) => Competition.fromJson(e)).toList();
  }

  Future<Competition> getCompetition(String id) async {
    return (await getData)
        .where(
          (element) => element.codeEdition == id,
        )
        .toList()[0];
  }
}

List<Map<String, dynamic>> competitions = [
  {
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé"
  },
  {
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou"
  },
  {
    "codeEdition": "aka2024",
    "anneeEdition": "2024",
    "nomEdition": "Ligue Fouta Edition 2024",
    "codeCompetition": "aka",
    "nomCompetition": "Ligue Fouta",
    "localiteCompetition": "Nouakchott"
  },
  {
    "codeEdition": "can2024",
    "anneeEdition": "2023",
    "nomEdition": "Coupe d'Afrique des Nations  2023",
    "codeCompetition": "can",
    "nomCompetition": "Coupe d'afrique des Nations",
    "localiteCompetition": "africa"
  }
];
