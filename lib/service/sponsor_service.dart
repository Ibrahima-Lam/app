import 'package:app/models/sponsor.dart';
import 'package:app/service/local_service.dart';
import 'package:app/service/remote_service.dart';

class SponsorService {
  static LocalService get service => LocalService('sponsor.json');
  static const String collection = 'sponsor';

  static int _sorter(Sponsor a, Sponsor b) =>
      ((b.date ?? '').compareTo(a.date ?? '')).toInt();

  static Future<List<Sponsor>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null)
        return data.map((e) => Sponsor.fromJson(e)).toList()..sort(_sorter);
    }
    return null;
  }

  static Future<List<Sponsor>> getData({bool remote = false}) async {
    if (await service.isLoadable() && !remote)
      return await getLocalData() ?? [];
    final List<Sponsor> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Sponsor>> getRemoteData() async {
    try {
      final List data = await RemoteService.loadData(collection);
      if (data.isNotEmpty) await service.setData(data);
      return data.map((e) => Sponsor.fromJson(e)).toList()..sort(_sorter);
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addSponsor(Sponsor sponsor) async {
    final bool res = await RemoteService.setData(
        collection, sponsor.idSponsor, sponsor.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> editSponsor(String idSponsor, Sponsor sponsor) async {
    final bool res =
        await RemoteService.setData(collection, idSponsor, sponsor.toJson());
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }

  static Future<bool> deleteSponsor(String idSponsor) async {
    final bool res = await RemoteService.deleteData(collection, idSponsor);
    if (res) await service.setData(await RemoteService.loadData(collection));
    return res;
  }
}
