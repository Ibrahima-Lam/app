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

  static Future<List<Coach>> getCoachs() async {
    if (await service.isLoadable()) return await getLocalData() ?? [];
    await Future.delayed(const Duration(seconds: 1));
    // Todo changer coaches par remote data
    await service.setData(coachs);
    return coachs.map((e) => Coach.fromJson(e)).toList();
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
