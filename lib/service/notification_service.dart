import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:fscore/core/service/storage_service.dart';

class NotificationService {
  final String key = 'abonnements';
  final StorageService storageService;

  NotificationService() : storageService = StorageService('abonnements');

  Future<List<String>> getAbonnements() async {
    final abonnements = await storageService.getList();
    return abonnements ?? [];
  }

  Future<void> setAbonnements(List<String> abonnements) async {
    await storageService.setList(abonnements);
  }

  Future<void> addAbonnement(String abonnement) async {
    if (!kIsWeb) {
      await FirebaseMessaging.instance.subscribeToTopic(abonnement);
    }
    final abonnements = await getAbonnements();
    abonnements.add(abonnement);
    await storageService.setList(abonnements);
  }

  Future<void> removeAbonnement(String abonnement) async {
    if (!kIsWeb) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(abonnement);
    }
    final abonnements = await getAbonnements();
    abonnements.remove(abonnement);
    await storageService.setList(abonnements);
  }
}
