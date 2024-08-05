import 'package:app/models/competition.dart';
import 'package:app/service/local_service.dart';
import 'package:app/service/remote_service.dart';

class CompetitionService {
  static const file = 'competition.json';
  static const collection = 'competition';
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

  Future<List<Competition>> getData({bool remote = false}) async {
    if (await service.isLoadable() && !remote)
      return await getLocalData() ?? [];
    final List<Competition> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  Future<List<Competition>> getRemoteData() async {
    try {
      final data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return data.map((e) => Competition.fromJson(e)).toList()..sort(_sorter);
    } catch (e) {
      return [];
    }
  }

  Future<bool> addCompetition(Competition competition) async {
    final bool res = await RemoteService.setData(
        collection, competition.codeEdition, competition.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  Future<bool> removeCompetition(String codeEdition) async {
    final bool res = await RemoteService.deleteData(collection, codeEdition);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  Future<bool> editCompetition(
      String codeEdition, Competition competition) async {
    final bool res = await RemoteService.setData(
        collection, codeEdition, competition.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
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
