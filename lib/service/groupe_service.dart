import 'package:app/models/groupe.dart';
import 'package:app/models/phase.dart';
import 'package:app/core/service/local_service.dart';
import 'package:app/service/phase_service.dart';
import 'package:app/core/service/remote_service.dart';

class GroupeService {
  static LocalService get service => LocalService('groupe.json');
  static const String collection = 'groupe';

  static Future<List<Groupe>> _toGroupes(List groupes) async {
    final List<Phase> phases = await PhaseService.getData();
    return groupes
        .where((element) =>
            phases.any((e) => e.codePhase == element['codePhase'].toString()))
        .map((e) {
      Phase phase =
          phases.singleWhere((elmt) => elmt.codePhase == e['codePhase']);
      return Groupe.fromJson(e, phase);
    }).toList();
  }

  static Future<List<Groupe>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null) return _toGroupes(data);
    }
    return null;
  }

  static Future<List<Groupe>> getData({bool remote = false}) async {
    if (await service.isLoadable() && !remote)
      return await getLocalData() ?? [];
    final List<Groupe> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Groupe>> getRemoteData() async {
    try {
      final data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return _toGroupes(data);
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addGroupe(Groupe groupe) async {
    final bool res = await RemoteService.setData(
        collection, groupe.idGroupe, groupe.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> editGroupe(String idGroupe, Groupe groupe) async {
    final bool res =
        await RemoteService.editData(collection, idGroupe, groupe.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> removeGroupe(String idGroupe) async {
    final bool res = await RemoteService.deleteData(collection, idGroupe);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}
