import 'package:app/models/app_paramettre.dart';
import 'package:app/service/app_paramettre_service.dart';
import 'package:flutter/material.dart';

class AppParamettreProvider extends ChangeNotifier {
  AppParamettre appParamettre;
  AppParamettreProvider({required this.appParamettre});

  Future<AppParamettre> getData() async {
    AppParamettre paramettre = await AppParamettreService().getData();

    return paramettre;
  }

  Future<void> setData(AppParamettre paramettre) async {
    await AppParamettreService().setData(paramettre);
    await getData();
    notifyListeners();
  }
}
