import 'package:app/models/competition.dart';
import 'package:app/core/service/local_service.dart';
import 'package:app/core/service/remote_service.dart';

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
