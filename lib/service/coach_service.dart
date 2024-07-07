import 'package:app/models/coachs/coach.dart';

class CoachService {
  static List<Coach> getCoachs() {
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
