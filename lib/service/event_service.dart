import 'package:app/models/event.dart';
import 'package:app/service/but_service.dart';
import 'package:app/service/sanction_service.dart';

class EventService {
  Future<List<Event>> getData() async {
    return [...await ButService.getData(), ...await SanctionService.getData()];
  }

  Future<void> setData() async {}
}
