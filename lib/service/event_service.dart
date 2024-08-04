import 'package:app/models/event.dart';
import 'package:app/service/but_service.dart';
import 'package:app/service/changement_service.dart';
import 'package:app/service/sanction_service.dart';

class EventService {
  Future<List<Event>> getData({bool remote = false}) async {
    return [
      ...await ButService.getData(remote: remote),
      ...await SanctionService.getData(remote: remote),
      ...await ChangementService.getData(remote: remote)
    ];
  }

  Future<void> setData() async {}
}
