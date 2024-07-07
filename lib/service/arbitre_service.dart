import 'package:app/models/arbitres/arbitre.dart';

class ArbitreService {
  static List<Arbitre> getArbitres() {
    return arbitres.map((e) => Arbitre.fromJson(e)).toList();
  }
}

List<Map<String, dynamic>> arbitres = [
  {
    'idArbitre': 'a1',
    'nomArbitre': 'Ibrahima Sy',
    'role': 'principale',
    'idEdition': 'thialgou2023',
    'imageUrl': '',
  },
  {
    'idArbitre': 'a2',
    'nomArbitre': 'Siley Sy',
    'role': 'principale',
    'imageUrl': '',
    'idEdition': 'thialgou2023',
  },
  {
    'idArbitre': 'a3',
    'nomArbitre': 'Alisein dia',
    'role': 'assistant',
    'idEdition': 'thialgou2023',
    'imageUrl': '',
  },
  {
    'idArbitre': 'a4',
    'nomArbitre': 'Saidou Bocar',
    'role': 'assistant',
    'idEdition': 'thialgou2023',
    'imageUrl': '',
  },
];
