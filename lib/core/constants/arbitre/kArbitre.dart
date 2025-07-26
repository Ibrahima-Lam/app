import 'package:fscore/controllers/competition/date.dart';
import 'package:fscore/models/composition.dart';

final ArbitreComposition kArbitreComposition = ArbitreComposition(
    idArbitre: 'ar1',
    idComposition: 'A' + DateController.dateCollapsed,
    role: 'principale',
    idGame: 'AR' + 1.toString(),
    nom: 'Directeur');
final List<ArbitreComposition> kArbitres = [
  ArbitreComposition(
      idArbitre: 'ar2',
      idComposition: 'A' + DateController.dateCollapsed,
      role: 'principale',
      idGame: 'AR' + 1.toString(),
      nom: 'Directeur'),
  ArbitreComposition(
      idArbitre: 'ar3',
      idComposition: 'A' + DateController.dateCollapsed,
      role: 'assistant',
      idGame: 'AR' + 2.toString(),
      nom: 'Premier Assistant'),
  ArbitreComposition(
      idArbitre: 'ar4',
      idComposition: 'A' + DateController.dateCollapsed,
      role: 'assistant',
      idGame: 'AR' + 3.toString(),
      nom: 'Deuxieme Assistant'),
  ArbitreComposition(
    idArbitre: 'ar5',
    idComposition: 'A' + DateController.dateCollapsed,
    role: '4 eme',
    idGame: 'AR' + 4.toString(),
    nom: '4 eme Arbitre',
  ),
];
