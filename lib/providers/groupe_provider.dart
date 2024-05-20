import 'package:app/collection/groupe_collection.dart';
import 'package:app/models/groupe.dart';
import 'package:app/service/groupe_service.dart';
import 'package:flutter/material.dart';

class GroupeProvider extends ChangeNotifier {
  GroupeCollection _groupeCollection = GroupeCollection([]);

  void set groupeCollection(List<Groupe> val) {
    _groupeCollection = GroupeCollection(val);
    notifyListeners();
  }

  Future<GroupeCollection> getGroupes() async {
    if (_groupeCollection.isEmpty) {
      groupeCollection = await GroupeService.getData();
    }
    return _groupeCollection;
  }
}
