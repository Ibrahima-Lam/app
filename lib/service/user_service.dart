import 'package:app/models/user.dart';

class UserService {
  static Future<User?> getUser(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    User? user;
    try {
      user = users.lastWhere((e) => e.email == email && e.password == password);
    } catch (e) {
      return null;
    }
    return user;
  }
}

List<User> users = [
  User(
      id: 'id1',
      name: 'Amadou Lam',
      email: 'amadoulam@gmail.com',
      password: 'pass'),
  User(
      id: 'id2',
      name: 'Ibrahima Lam',
      email: 'ibrahimaaboulam@gmail.com',
      password: 'pass'),
  User(id: 'id3', name: 'Lam', email: 'ibrahima@gmail.com', password: 'pass'),
  User(id: 'id4', name: 'Root', email: 'root@gmail.com', password: 'pass'),
];
