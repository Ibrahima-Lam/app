import 'package:app/models/coachs/coach.dart';
import 'package:app/service/local_service.dart';

class CoachService {
  static LocalService get service => LocalService('coach.json');

  static Future<List<Coach>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null) return data.map((e) => Coach.fromJson(e)).toList();
    }
    return null;
  }

  static Future<List<Coach>> getData({bool remote = false}) async {
    if (await service.isLoadable() && !remote)
      return await getLocalData() ?? [];
    final List<Coach> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Coach>> getRemoteData() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (coachs.isNotEmpty) await service.setData(coachs);
      return coachs.map((e) => Coach.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addCoach(Coach coach) async {
    if (coachs.any((element) =>
        element['idParticipant'] == coach.idParticipant &&
        element['nomCoach'] == coach.nomCoach &&
        element['role'] == coach.role)) return false;
    coachs.add(coach.toJson());
    return true;
  }

  static Future<bool> editCoach(String idCoach, Coach coach) async {
    if (coachs.any((element) => element['idCoach'] == idCoach)) {
      int index = coachs.indexWhere((element) => element['idCoach'] == idCoach);
      if (index >= 0) coachs[index] = coach.toJson();
      return true;
    }
    return false;
  }

  static Future<bool> deleteCoach(String idCoach) async {
    if (coachs.any((element) => element['idCoach'] == idCoach)) {
      coachs.removeWhere((element) => element['idCoach'] == idCoach);
      return true;
    }
    return true;
  }
}

List<Map<String, dynamic>> coachs = [
  {
    'idCoach': 'c1',
    'nomCoach': 'Wagne',
    'role': 'coach',
    'idParticipant': '25',
    'imageUrl': '',
  },
  {
    'idCoach': 'c2',
    'nomCoach': 'Bathie',
    'role': 'coach',
    'imageUrl': '',
    'idParticipant': '26',
  },
  {
    'idCoach': 'c3',
    'nomCoach': 'Cheikh',
    'role': 'coach',
    'idParticipant': '28',
    'imageUrl': '',
  },
];
