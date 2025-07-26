import 'package:fscore/models/scores/score.dart';
import 'package:fscore/core/service/local_service.dart';
import 'package:fscore/core/service/remote_service.dart';

class ScoreService {
  static LocalService get service => LocalService('score.json');
  static const String collection = 'score';

  static Future<List<Score>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null) return data.map((e) => Score.fromJson(e)).toList();
    }
    return null;
  }

  static Future<List<Score>> getData({bool remote = false}) async {
    final List<Score> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Score>> getRemoteData() async {
    try {
      final List data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return data.map((e) => Score.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Stream<List<Score>> listenData() {
    return RemoteService.listenData(collection).map((event) {
      service.setData(event);
      return event.map((e) => Score.fromJson(e)).toList();
    });
  }

  static Future<bool> addScore(Score score) async {
    final bool res =
        await RemoteService.setData(collection, score.idGame, score.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> editScore(String idGame, Score score) async {
    final bool res =
        await RemoteService.setData(collection, idGame, score.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> deleteScore(String idGame) async {
    final bool res = await RemoteService.deleteData(collection, idGame);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}
