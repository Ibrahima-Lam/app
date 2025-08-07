import 'package:flutter/foundation.dart';
import 'package:fscore/service/notification_service.dart';

// Todo: No used
class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService;
  NotificationProvider(this._notificationService);

  List<String> _abonnements = [];

  List<String> get abonnements => _abonnements;
  set abonnements(List<String> value) {
    _abonnements = value;
    notifyListeners();
  }

  Future<void> loadAbonnements() async {
    _abonnements = await _notificationService.getAbonnements();
    notifyListeners();
  }

  Future<void> addAbonnement(String abonnement) async {
    await _notificationService.addAbonnement(abonnement);
    await loadAbonnements();
  }

  Future<void> removeAbonnement(String abonnement) async {
    await _notificationService.removeAbonnement(abonnement);
    await loadAbonnements();
  }
}

ValueNotifier<int> unreadCountNotifier = ValueNotifier<int>(0);
