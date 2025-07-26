import 'package:fscore/models/composition.dart';
import 'package:fscore/core/service/local_service.dart';
import 'package:fscore/core/service/remote_service.dart';

class CompositionService {
  static LocalService get service => LocalService('composition.json');
  static const String collection = 'composition';

  static List<Composition> _toCompositions(List data) {
    return data.map((e) => _toComposition(e)).toList();
  }

  static Composition _toComposition(Map<String, dynamic> data) {
    if (data['idJoueur'] != null) {
      return JoueurComposition.fromJson(data);
    } else if (data['idCoach'] != null) {
      return CoachComposition.fromJson(data);
    } else if (data['idArbitre'] != null) {
      return ArbitreComposition.fromJson(data);
    }
    return StaffComposition.fromJson(data);
  }

  static Future<bool> addAllCompositions(
      String idGame, List<Composition> compos) async {
    return setAllCompositions(idGame, compos);
  }

  static Future<bool> setAllCompositions(
      String idGame, List<Composition> compos) async {
    for (var element in compos) {
      if (!await setComposition(element.idComposition, element)) return false;
    }
    return true;
  }

  static Future<List<Composition>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null) return _toCompositions(data);
    }
    return null;
  }

  static Future<List<Composition>> getData({bool remote = false}) async {
    if (await service.isLoadable(2) && !remote)
      return await getLocalData() ?? [];
    final List<Composition> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Composition>> getRemoteData() async {
    try {
      final List data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return _toCompositions(data);
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addComposition(Composition compos) async {
    final bool res = await RemoteService.setData(
        collection, compos.idComposition, compos.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> editComposition(
      String idComposition, Composition compos) async {
    final bool res =
        await RemoteService.setData(collection, idComposition, compos.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> setComposition(
      String idComposition, Composition compos) async {
    final bool res =
        await RemoteService.setData(collection, idComposition, compos.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> deleteComposition(String idComposition) async {
    final bool res = await RemoteService.deleteData(collection, idComposition);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}
