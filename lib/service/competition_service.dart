import 'package:app/models/competition.dart';
import 'package:app/service/local_service.dart';

class CompetitionService {
  static const file = 'competition.json';
  final LocalService service;

  const CompetitionService([this.service = const LocalService(file)]);

  int _sorter(Competition a, Competition b) =>
      ((b.rating ?? 0) - (a.rating ?? 0)).toInt();

  Future<List<Competition>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null)
        return data.map((e) => Competition.fromJson(e)).toList()..sort(_sorter);
    }
    return null;
  }

  Future<List<Competition>> getData() async {
    if (await service.isLoadable()) return await getLocalData() ?? [];
    await Future.delayed(const Duration(seconds: 1));
    await service.setData(competitions);
    return competitions.map((e) => Competition.fromJson(e)).toList()
      ..sort(_sorter);
  }
}

List<Map<String, dynamic>> competitions = [
  {
    "codeEdition": "district2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi district de Boghé Edition 2023",
    "codeCompetition": "district",
    "nomCompetition": "Tournoi district de Boghé",
    "localiteCompetition": "Boghé",
    "rating": 2,
  },
  {
    "codeEdition": "thialgou2023",
    "anneeEdition": "2023",
    "nomEdition": "Tournoi Pélle Thialgou Edition 2023",
    "codeCompetition": "thialgou",
    "nomCompetition": "Tournoi Pellé Thialgou Edition 2023",
    "localiteCompetition": "Thialgou",
    "rating": 3.5,
  },
  {
    "codeEdition": "aka2024",
    "anneeEdition": "2024",
    "nomEdition": "Ligue Fouta Edition 2024",
    "codeCompetition": "aka",
    "nomCompetition": "Ligue Fouta",
    "localiteCompetition": "Nouakchott",
    "rating": 2,
  },
  {
    "codeEdition": "can2024",
    "anneeEdition": "2023",
    "nomEdition": "Coupe d'Afrique des Nations  2023",
    "codeCompetition": "can",
    "nomCompetition": "Coupe d'afrique des Nations",
    "localiteCompetition": "africa",
  }
];
