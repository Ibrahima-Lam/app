import 'package:app/core/extension/list_extension.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:app/models/user.dart';

class UserService {
  static Future<User?> getUser(String email, String password) async {
    User? user = users
        .singleWhereOrNull((e) => e.email == email && e.password == password);
    if (user != null) return user;
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential uc = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (uc.user != null) {
        return User(
            id: uc.user?.uid ?? '',
            name: uc.user?.displayName ?? '',
            email: email,
            password: password);
      }
      return null;
    } catch (e) {
      return null;
    }
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
