import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final String key;
  StorageService(this.key);

  Future<SharedPreferences> get storage async =>
      await SharedPreferences.getInstance();
  Future<void> setString(String data) async {
    final prefs = await storage;
    await prefs.setString(key, data);
  }

  Future<String?> getString() async {
    final prefs = await storage;
    return prefs.getString(key);
  }

  Future<List<String>?> getList() async {
    final prefs = await storage;
    return prefs.getStringList(key);
  }

  Future<void> setList(List<String> data) async {
    final prefs = await storage;
    await prefs.setStringList(key, data);
  }

  Future<void> remove() async {
    final prefs = await storage;
    await prefs.remove(key);
  }

  Future<bool> containsKey() async {
    final prefs = await storage;
    return prefs.containsKey(key);
  }

  Future<void> clear() async {
    final prefs = await storage;
    await prefs.clear();
  }
}
