import 'package:app/models/paramettre.dart';
import 'package:app/service/local_service.dart';
import 'package:flutter/material.dart';

class ParamettreService {
  static LocalService get service => LocalService('paramettrages.json');

  static Future<List<Paramettre>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());

      if (data != null) return data.map((e) => Paramettre.fromJson(e)).toList();
    }
    return null;
  }

  static Future<List<Paramettre>> getData({bool remote = false}) async {
    if (await service.isLoadable() && !remote)
      return await getLocalData() ?? [];
    final List<Paramettre> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Paramettre>> getRemoteData() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (paramettres.isNotEmpty) await service.setData(paramettres);
      return paramettres.map((e) => Paramettre.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addData(Paramettre paramettre) async {
    await Future.delayed(Durations.extralong4);
    paramettres.add(paramettre.toJson());
    return true;
  }

  static Future<bool> updateData(
      String idEdition, Paramettre paramettre) async {
    await Future.delayed(Durations.extralong4);
    paramettres.removeWhere((element) => element['idEdition'] == idEdition);
    paramettres.add(paramettre.toJson());
    return true;
  }

  static Future<bool> removeData(String idEdition) async {
    await Future.delayed(Durations.extralong4);
    paramettres.removeWhere((element) => element['idEdition'] == idEdition);
    return true;
  }
}

List<Map<String, dynamic>> paramettres = [
  {
    'idParamettre': 'p1',
    'idEdition': 'thialgou2023',
    'success': 4,
    'users': "ibrahimaaboulam@gmail.com,root@gmail.com",
  },
  {
    'idParamettre': 'p2',
    'idEdition': 'district2023',
    'success': 16,
    'users': "amadoulam@gmail.com,root@gmail.com",
  },
];
