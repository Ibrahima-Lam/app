import 'package:fscore/models/arbitres/arbitre.dart';
import 'package:fscore/service/arbitre_service.dart';
import 'package:flutter/material.dart';

class ArbitreProvider extends ChangeNotifier {
  var _arbitres = <Arbitre>[];

  List<Arbitre> get arbitres => _arbitres;
  void set arbitres(List<Arbitre> val) {
    _arbitres = val;
    notifyListeners();
  }

  Future<List<Arbitre>> getData({bool remote = false}) async {
    if (_arbitres.isEmpty || remote) {
      arbitres = await ArbitreService.getData(remote: remote);
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

  Future<bool> addArbitre(Arbitre arbitre) async {
    final bool result = await ArbitreService.addArbitre(arbitre);
    if (result) await getData(remote: true);
    return result;
  }

  Future<bool> editArbitre(String idArbitre, Arbitre arbitre) async {
    final bool result = await ArbitreService.editArbitre(idArbitre, arbitre);
    if (result) await getData(remote: true);
    return result;
  }

  Future<bool> deleteArbitre(String idArbitre) async {
    final bool result = await ArbitreService.deleteArbitre(idArbitre);
    if (result) await getData(remote: true);
    return result;
  }
}
