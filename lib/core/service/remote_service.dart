import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class RemoteService {
  const RemoteService();
  static FirebaseFirestore get _db => FirebaseFirestore.instance;
  static Future<bool> get isNotConnected async =>
      (await Connectivity().checkConnectivity())
          .contains(ConnectivityResult.none);

  static Future<bool> get isConnected async => !await isNotConnected;

  static Future<bool> addData(
      String collection, Map<String, dynamic> data) async {
    try {
      await _db.collection(collection).add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setData(
      String collection, String document, Map<String, dynamic> data) async {
    try {
      await _db.collection(collection).doc(document).set(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List> loadData(String collection) async {
    List data = [];
    try {
      if (await isNotConnected) return [];
      await _db.collection(collection).get().then((value) {
        data = value.docs.map((e) => e.data()).toList();
      });
    } catch (e) {
      return [];
    }
    return data;
  }

  static Stream<List<Map<String, dynamic>>> listenData(
      String collection) async* {
    try {
      yield* _db.collection(collection).snapshots().map((event) {
        return event.docs.map((e) => e.data()).toList();
      });
    } catch (e) {
      yield [];
    }
  }

  static Future<bool> deleteData(String collection, String document) async {
    try {
      if (await isNotConnected) return false;
      await _db.collection(collection).doc(document).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> editData(
      String collection, String document, Map<String, dynamic> data) async {
    try {
      if (await isNotConnected) return false;
      await _db.collection(collection).doc(document).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }
}
