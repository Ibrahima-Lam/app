import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteService {
  const RemoteService();
  static get _db => FirebaseFirestore.instance;

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
      await _db.collection(collection).get().then((value) {
        data = value.docs.map((e) => e.data()).toList();
      });
    } catch (e) {
      return [];
    }
    return data;
  }

  static Stream<DocumentSnapshot> listenData(
      String collection, String document) {
    try {
      return _db
          .collection(collection)
          .doc(document)
          .snapshots()
          .map((event) => event.data());
    } catch (e) {
      return Stream.empty();
    }
  }

  static Future<bool> deleteData(String collection, String document) async {
    try {
      await _db.collection(collection).doc(document).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> editData(
      String collection, String document, Map<String, dynamic> data) async {
    try {
      await _db.collection(collection).doc(document).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }
}
