import 'package:app/models/game.dart';
import 'package:app/models/niveau.dart';

class NiveauController {
  static List<Niveau> getGamesNiveau(List<Game> games) {
    List<String> liste = [];
    List<Niveau> niveaux = [];
    games.sort((Game a, Game b) {
      if ((a.dateGame ?? '').compareTo(b.dateGame ?? '') != 0)
        return (a.dateGame ?? '').compareTo(b.dateGame ?? '');
      return (a.heureGame ?? '').compareTo(b.heureGame ?? '');
    });
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
