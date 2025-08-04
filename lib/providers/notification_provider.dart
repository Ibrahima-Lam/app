import 'package:flutter/foundation.dart';

// Todo: No used
class NotificationProvider extends ChangeNotifier {
  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  void incrementUnreadCount() {
    _unreadCount++;
    notifyListeners();
  }

  void decrementUnreadCount() {
    _unreadCount--;
    notifyListeners();
  }
}

ValueNotifier<int> unreadCountNotifier = ValueNotifier<int>(0);
