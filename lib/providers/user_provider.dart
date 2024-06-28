import 'package:app/models/user.dart';
import 'package:app/service/user_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  UserProvider([this._user]) {
    UserService.getData().then((value) {
      user = value;
    });
  }

  User? get user => _user;
  void set user(User? val) {
    _user = val;
    notifyListeners();
  }

  void changeUser() async {
    user = user == null ? await UserService.getData() : null;
  }
}
