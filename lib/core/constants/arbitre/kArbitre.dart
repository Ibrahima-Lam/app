import 'package:app/models/composition.dart';

final ArbitreComposition kArbitreComposition = ArbitreComposition(
    role: 'principale', idGame: 'AR' + 1.toString(), nom: 'Directeur');
final List<ArbitreComposition> kArbitres = [
  ArbitreComposition(
      role: 'principale', idGame: 'AR' + 1.toString(), nom: 'Directeur'),
  ArbitreComposition(
      role: 'assistant', idGame: 'AR' + 2.toString(), nom: 'Premier Assistant'),
  ArbitreComposition(
      role: 'assistant',
      idGame: 'AR' + 3.toString(),
      nom: 'Deuxieme Assistant'),
  ArbitreComposition(
    role: '4 eme',
    idGame: 'AR' + 4.toString(),
    nom: '4 eme Arbitre',
  ),
];
