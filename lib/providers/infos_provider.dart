import 'package:app/models/infos.dart';
import 'package:app/service/infos_service.dart';
import 'package:flutter/material.dart';

class InfosProvider extends ChangeNotifier {
  List<Infos> infos = [];

  Future<List<Infos>> getInformations() async {
    if (infos.length == 0) {
      infos = await InfosService.getData();
      notifyListeners();
    }
    return infos;
  }
}
