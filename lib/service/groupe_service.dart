import 'package:app/models/groupe.dart';
import 'package:app/models/phase.dart';
import 'package:app/service/phase_service.dart';

class GroupeService {
  static Future<List<Groupe>> getData() async {
    List<Phase> phases = await PhaseService.getData();
    return groupes.map((e) {
      Phase phase =
          phases.singleWhere((elmt) => elmt.codePhase == e['codePhase']);
      return Groupe.fromJson(e, phase);
    }).toList();
  }
}

List<Map<String, dynamic>> groupes = [
  {
    "idGroupe": 9,
    "nomGroupe": "A",
    "codePhase": "grp",
    "codeEdition": "thialgou2023",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe"
  },
  {
    "idGroupe": 10,
    "nomGroupe": "B",
    "codePhase": "grp",
    "codeEdition": "thialgou2023",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe"
  },
  {
    "idGroupe": 12,
    "nomGroupe": "C",
    "codePhase": "df",
    "codeEdition": "thialgou2023",
    "nomPhase": "Demi-finale",
    "typePhase": "elimination"
  },
  {
    "idGroupe": 13,
    "nomGroupe": "D",
    "codePhase": "fn",
    "codeEdition": "thialgou2023",
    "nomPhase": "Finale",
    "typePhase": "elimination"
  },
  {
    "idGroupe": 1,
    "nomGroupe": "A",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe"
  },
  {
    "idGroupe": 2,
    "nomGroupe": "B",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe"
  },
  {
    "idGroupe": 3,
    "nomGroupe": "C",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe"
  },
  {
    "idGroupe": 4,
    "nomGroupe": "D",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe"
  },
  {
    "idGroupe": 5,
    "nomGroupe": "E",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe"
  },
  {
    "idGroupe": 6,
    "nomGroupe": "F",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe"
  },
  {
    "idGroupe": 7,
    "nomGroupe": "G",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe"
  },
  {
    "idGroupe": 8,
    "nomGroupe": "H",
    "codePhase": "grp",
    "codeEdition": "district2023",
    "nomPhase": "Phase de groupe",
    "typePhase": "groupe"
  },
  {
    "idGroupe": 11,
    "nomGroupe": "I",
    "codePhase": "qf",
    "codeEdition": "district2023",
    "nomPhase": "Quart de finale",
    "typePhase": "elimination"
  }
];
