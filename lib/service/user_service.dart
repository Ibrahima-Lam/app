import 'package:app/models/user.dart';

class UserService {
  static Future<User?> getData() async {
    await Future.delayed(Duration(seconds: 1));
    return User(
        id: 'id',
        name: 'username',
        email: 'hjjfjdfg@gmail.com',
        password: 'passe');
  }
}
