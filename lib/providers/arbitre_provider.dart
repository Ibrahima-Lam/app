import 'package:app/models/arbitres/arbitre.dart';
import 'package:app/service/arbitre_service.dart';
import 'package:flutter/material.dart';

class ArbitreProvider extends ChangeNotifier {
  var _arbitres = <Arbitre>[];

  List<Arbitre> get arbitres => _arbitres;
  void set arbitres(List<Arbitre> val) => _arbitres = val;

  Future<List<Arbitre>> getData() async {
    if (_arbitres.isEmpty) {
      arbitres = await ArbitreService.getArbitres();
    }
    return arbitres;
  }

  Arbitre? getArbitre(String id) {
    try {
      return arbitres.singleWhere((element) => element.idArbitre == id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> checkArbitre(String id) async {
    if (arbitres.isEmpty) await getData();
    return arbitres.any((element) => element.idArbitre == id);
  }
}
