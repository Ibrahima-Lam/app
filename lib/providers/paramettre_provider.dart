import 'package:app/core/extension/list_extension.dart';
import 'package:app/models/paramettre.dart';
import 'package:app/providers/user_provider.dart';
import 'package:app/service/paramettre_service.dart';
import 'package:flutter/material.dart';

class ParamettreProvider extends ChangeNotifier {
  final UserProvider userProvider;

  List<Paramettre> _paramettres = [];
  ParamettreProvider({required this.userProvider}) {
    initData();
  }

  List<Paramettre> get paramettres => _paramettres;
  void set paramettres(List<Paramettre> val) {
    _paramettres = val;
    notifyListeners();
  }

  Paramettre? getCompetitionParamettre(String idEdition) {
    return paramettres
        .singleWhereOrNull((element) => element.idEdition == idEdition);
  }

  bool checkUser(String idEdition) {
    if (checkRootUser()) return true;
    if (userProvider.user == null) return false;
    Paramettre? paramettre;
    try {
      paramettre =
          paramettres.singleWhere((element) => element.idEdition == idEdition);
    } catch (e) {
      return false;
    }
    return paramettre.users.contains(userProvider.user!.email);
  }

  bool checkRootUser() {
    if (userProvider.user == null) return false;
    if (userProvider.user?.email == 'root@gmail.com' ||
        userProvider.user?.email == 'ibrahimaaboulam@gmail.com') return true;
    return false;
  }

  Future<List<Paramettre>> getData({bool remote = false}) async {
    paramettres = await ParamettreService.getData(remote: remote);

    return paramettres;
  }

  Future<List<Paramettre>> initData({bool remote = false}) async {
    _paramettres = await ParamettreService.getData(remote: remote);

    return paramettres;
  }

  Future<bool> updateParamettre(String idEdition, Paramettre paramettre) async {
    final bool res = await ParamettreService.updateData(idEdition, paramettre);
    if (res) await getData(remote: true);
    return res;
  }

  Future<bool> addParamettre(Paramettre paramettre) async {
    final bool res = await ParamettreService.addData(paramettre);
    if (res) await getData(remote: true);
    return res;
  }

  Future<bool> deleteParamettre(String idEdition) async {
    final bool res = await ParamettreService.removeData(idEdition);
    if (res) await getData(remote: true);
    return res;
  }
}
