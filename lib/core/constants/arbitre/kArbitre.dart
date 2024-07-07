import 'package:app/models/composition.dart';

final ArbitreComposition kArbitreComposition = ArbitreComposition(
    idArbitre: 'ar1',
    idComposition: DateTime.now().millisecondsSinceEpoch.toString(),
    role: 'principale',
    idGame: 'AR' + 1.toString(),
    nom: 'Directeur');
final List<ArbitreComposition> kArbitres = [
  ArbitreComposition(
      idArbitre: 'ar2',
      idComposition: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'principale',
      idGame: 'AR' + 1.toString(),
      nom: 'Directeur'),
  ArbitreComposition(
      idArbitre: 'ar3',
      idComposition: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'assistant',
      idGame: 'AR' + 2.toString(),
      nom: 'Premier Assistant'),
  ArbitreComposition(
      idArbitre: 'ar4',
      idComposition: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'assistant',
      idGame: 'AR' + 3.toString(),
      nom: 'Deuxieme Assistant'),
  ArbitreComposition(
    idArbitre: 'ar5',
    idComposition: DateTime.now().millisecondsSinceEpoch.toString(),
    role: '4 eme',
    idGame: 'AR' + 4.toString(),
    nom: '4 eme Arbitre',
  ),
];
