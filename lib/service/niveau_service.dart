import 'package:app/models/niveau.dart';

class NiveauService {
  Future<List<Niveau>> get getNiveaux async =>
      niveaux.map((e) => Niveau.fromJson(e)).toList();
}

const List<Map<String, dynamic>> niveaux = [
  {'codeNiveau': 'tr1', 'nomNiveau': 'tour 1', 'typeNiveau': 'groupe'},
  {'codeNiveau': 'tr2', 'nomNiveau': 'tour 2', 'typeNiveau': 'groupe'},
  {'codeNiveau': 'tr3', 'nomNiveau': 'tour 3', 'typeNiveau': 'groupe'},
  {'codeNiveau': 'tr4', 'nomNiveau': 'tour 4', 'typeNiveau': 'groupe'},
  {'codeNiveau': 'tr', 'nomNiveau': 'match de Groupe', 'typeNiveau': 'groupe'},
  {
    'codeNiveau': 'qf',
    'nomNiveau': 'Quart de Final',
    'typeNiveau': 'elimination'
  },
  {'codeNiveau': 'df', 'nomNiveau': 'Demi-finale', 'typeNiveau': 'elimination'},
  {'codeNiveau': 'fn', 'nomNiveau': 'Finale', 'typeNiveau': 'elimination'},
  {
    'codeNiveau': 'pf',
    'nomNiveau': 'Troisiéme place',
    'typeNiveau': 'elimination'
  },
];
