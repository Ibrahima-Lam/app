import 'package:fscore/models/user.dart';
import 'package:fscore/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final String _key = 'user';
  UserProvider([this._user]) {
    _getLocaleUser().then((value) {
      if (value == null) return;
      if (value.length < 2) return;
      String email = value[0];
      String password = value[1];
      connectUser(email, password, true);
    });
  }

  User? get user => _user;
  void set user(User? val) {
    _user = val;
    notifyListeners();
  }

  Future<bool> connectUser(String email, String password, bool remember) async {
    user = await UserService.getUser(email, password);
    if (user != null && remember) _setLocaleUser([user!.email, user!.password]);
    return user != null;
  }

  void deconnectUser() async {
    user = null;
    _removeLocaleUser();
  }

  Future<List<String>?> _getLocaleUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(_key);
  }

  void _setLocaleUser(List<String> values) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList(_key, values);
  }

  void _removeLocaleUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(_key);
  }
}
