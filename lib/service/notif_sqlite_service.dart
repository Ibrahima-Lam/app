import 'package:fscore/core/service/sqlite_service.dart';
import 'package:fscore/models/notification.dart';

class NotifSqliteService extends SqliteService {
  NotifSqliteService();

  Future insertNotif(Notif notif) async {
    await (await db).insert('notifs', notif.toJson()..remove('idNotif'));
  }

  Future<List<Notif>> getNotifs() async {
    final List<Map<String, dynamic>> maps = await (await db).query('notifs');
    return maps.map((e) => Notif.fromJson(e)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<List<Notif>> getNotifsByIdGame(String idGame) async {
    final List<Map<String, dynamic>> maps = await (await db)
        .query('notifs', where: 'idGame = ?', whereArgs: [idGame]);
    return maps.map((e) => Notif.fromJson(e)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future deleteNotif(String id) async {
    return (await db)
        .delete('notifs', where: 'idNotif = ?', whereArgs: [int.tryParse(id)]);
  }
}
