import 'package:app/models/phase.dart';

class PhaseService {
  static Future<List<Phase>> getData() async {
    return phases.map((e) => Phase.fromJson(e)).toList();
  }
}

List<Map<String, dynamic>> phases = [
  {
    "codePhase": "grp",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe",
    "ordrePhase": "a1grp"
  },
  {
    "codePhase": "fn",
    "nomPhase": "Finale",
    "typePhase": "elimination",
    "ordrePhase": "b7fn"
  },
  {
    "codePhase": "df",
    "nomPhase": "Demi-finale",
    "typePhase": "elimination",
    "ordrePhase": "b5df"
  },
  {
    "codePhase": "qf",
    "nomPhase": "Quart de finale",
    "typePhase": "elimination",
    "ordrePhase": "b4qf"
  },
  {
    "codePhase": "hf",
    "nomPhase": "Huitieme de finale",
    "typePhase": "elimination",
    "ordrePhase": "b3hf"
  },
  {
    "codePhase": "chpn",
    "nomPhase": "Championnat",
    "typePhase": "championnat",
    "ordrePhase": "c1chpn"
  }
];
