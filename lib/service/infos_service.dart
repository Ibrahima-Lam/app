import 'package:app/models/infos/infos.dart';
import 'package:app/service/local_service.dart';
import 'package:flutter/material.dart';

class InfosService {
  static LocalService get service => LocalService('infos.json');

  static int _sorter(Infos a, Infos b) =>
      (b.datetime.compareTo(a.datetime)).toInt();

  static Future<List<Infos>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null)
        return data.map((e) => Infos.fromJson(e)).toList()..sort(_sorter);
    }
    return null;
  }

  static Future<List<Infos>> getData({bool remote = false}) async {
    final List<Infos> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Infos>> getRemoteData() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (infos.isNotEmpty) await service.setData(infos);
      return infos.map((e) => Infos.fromJson(e)).toList()..sort(_sorter);
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addInfos(Infos info) async {
    await Future.delayed(Durations.extralong4);

    if (infos.any((element) =>
        element['title'] == info.title &&
        element['datetime'] == info.datetime &&
        element['idInfos'] != info.idInfos)) return false;
    infos.add(info.toJson());
    return true;
  }

  static Future<bool> editInfos(String idInfos, Infos info) async {
    await Future.delayed(Durations.extralong4);
    int index = infos.indexWhere((element) => element['idInfos'] == idInfos);
    if (index == -1) return false;
    infos[index] = info.toJson();
    return true;
  }

  static Future<bool> deleteInfos(String idInfos) async {
    if (infos.any((element) => element['idInfos'] == idInfos)) {
      await Future.delayed(Durations.extralong4);
      infos.removeWhere((element) => element['idInfos'] == idInfos);
      return true;
    }
    return false;
  }
}

final List<Map<String, dynamic>> infos = [
  {
    'idInfos': '1',
    'title': 'Title of the content',
    'text':
        'Hello this the content of the information after the breaking news. I hope you will understand it.',
    'datetime': DateTime.now().toString(),
    'source': 'RMC sport',
    'idParticipant': '25',
    'idJoueur': '35',
    'idGame': '1',
    'idEdition': 'thialgou2023',
  },
  {
    'idInfos': '2',
    'title': 'Title of the content',
    'text':
        'Hello this the content of the information after the breaking news. I hope you will understand it.',
    'datetime': DateTime.now().toString(),
    'source': 'RMC sport',
    'idParticipant': '25',
    'idJoueur': '35',
    'idGame': '1',
    'idEdition': 'thialgou2023',
  }
];
