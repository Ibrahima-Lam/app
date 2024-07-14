import 'package:app/models/game.dart';
import 'package:app/models/niveau.dart';

class NiveauController {
  static List<Niveau> getGamesNiveau(List<Game> games) {
    List<String> liste = [];
    List<Niveau> niveaux = [];
    games.sort((a, b) => a.dateGame!.compareTo(b.dateGame!));
    for (Game e in games) {
      if (!liste.contains(e.codeNiveau)) {
        liste.add(e.codeNiveau!);
        niveaux.add(e.niveau);
      }
    }
    niveaux.sort((a, b) => a.ordreNiveau.compareTo(b.ordreNiveau));
    return niveaux;
  }
}
