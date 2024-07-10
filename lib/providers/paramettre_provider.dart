import 'package:app/models/paramettre.dart';
import 'package:app/providers/user_provider.dart';
import 'package:app/service/paramettre_service.dart';
import 'package:flutter/material.dart';

class ParamettreProvider extends ChangeNotifier {
  final UserProvider userProvider;

  List<Paramettre> _paramettres = [];
  ParamettreProvider({required this.userProvider}) {
    getData();
  }

  List<Paramettre> get paramettres => _paramettres;
  void set paramettres(List<Paramettre> val) {
    _paramettres = val;
    notifyListeners();
  }

  bool checkUser(String idEdition) {
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

  Future<List<Paramettre>> getData() async {
    paramettres = await ParamettreService.getData();

    return paramettres;
  }
}
