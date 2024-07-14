import 'package:app/core/enums/game_etat_enum.dart';
import 'package:app/models/game.dart';
import 'package:app/models/participation.dart';
import 'package:app/models/stat.dart';

class Classeur {
  final List<String> criteresDefaut = [
    "pts",
    "diff",
    "match",
    "bm",
    "be",
    "id"
  ];
  final List<Game> games;
  final List<Participation> equipes;
  Classeur({required this.games, required this.equipes});

  List<Stat> classer(
      {List<String>? criteres, int Function(Stat, Stat)? callback}) {
    List<Stat> stats = teamStat(teamGamesStat());
    stats.sort((a, b) {
      return sorter(a, b,
          criteres: criteres ?? criteresDefaut, callback: callback);
    });
    for (int i = 0; i < stats.length; i++) {
      stats[i].num = i + 1;
      stats[i].playing = isPlaying(stats[i].id);
    }
    return stats;
  }

  bool isPlaying(String id) {
    for (Game game in games) {
      if ((game.idHome == id || game.idAway == id) &&
          (game.etat.etat == GameEtat.direct ||
              game.etat.etat == GameEtat.pause)) {
        return true;
      }
    }
    return false;
  }

  int sorter(Stat a, Stat b,
      {required List<String> criteres, int Function(Stat, Stat)? callback}) {
    for (String key in criteres) {
      if (key == 'match') {
        final int res = confrontation(a, b);
        if (res != 0) return res;
      }
      if (key == 'call') {
        int res = callback != null ? callback(a, b) : 0;
        if (res != 0) {
          return res;
        } else {
          continue;
        }
      }
      if (a.toJson().containsKey(key)) {
        if (a.toJson()[key] == b.toJson()[key]) {
          continue;
        }
        if (key == "id" || key == "be") {
          return a.toJson()[key] <= b.toJson()[key] ? -1 : 1;
        }
        return a.toJson()[key] > b.toJson()[key] ? -1 : 1;
      }
    }
    return 0;
  }

  int confrontation(Stat a, Stat b) {
    List<Game> matchs = games
        .where((game) =>
            game.idHome == a.id && game.idAway == b.id ||
            game.idAway == a.id && game.idHome == b.id)
        .toList();
    if (matchs.length == 2) {
      Game aller = matchs[0];
      Game retour = matchs[1];
      int diff = (aller.idHome == a.id)
          ? (aller.score!.homeScore! + retour.score!.awayScore!) -
              (aller.score!.awayScore! + retour.score!.homeScore!)
          : -((aller.score!.homeScore! + retour.score!.awayScore!) -
              (aller.score!.awayScore! + retour.score!.homeScore!));
      if (diff != 0) {
        return diff > 0 ? -1 : 1;
      }
    }
    if (matchs.isNotEmpty) {
      Game match = matchs[0];
      int diff = (match.idHome == a.id)
          ? match.score!.homeScore! - match.score!.awayScore!
          : -(match.score!.homeScore! - match.score!.awayScore!);
      if (diff != 0) {
        return diff > 0 ? -1 : 1;
      }
    }
    return 0;
  }

  List<Stat> teamGamesStat() {
    List<Stat> elements = [];
    for (Participation equipe in equipes) {
      final String indice = equipe.idParticipant;
      List<Game> homeGames =
          games.where((game) => indice.toString() == game.idHome).toList();
      for (Game element in homeGames) {
        elements.add(Stat(
          id: element.idHome,
          nom: element.home.nomEquipe,
          bm: element.score!.homeScore!,
          be: element.score!.awayScore!,
          diff: element.score!.homeScore! - element.score!.awayScore!,
          date: element.dateGame,
          imageUrl: element.home.imageUrl,
        ));
      }
      List<Game> awayGames =
          games.where((game) => indice.toString() == game.idAway).toList();
      for (Game element in awayGames) {
        elements.add(Stat(
          id: element.idAway,
          nom: element.away.nomEquipe,
          bm: element.score!.awayScore!,
          be: element.score!.homeScore!,
          diff: element.score!.awayScore! - element.score!.homeScore!,
          date: element.dateGame,
          imageUrl: element.away.imageUrl,
        ));
      }
    }
    elements.sort((a, b) => a.date!.compareTo(b.date!));
    return elements;
  }

  List<Stat> teamStat(List<Stat> stats) {
    List<Stat> data = [];
    for (Participation equipe in equipes) {
      Stat stat = stats
          .where((statElement) =>
              statElement.id == equipe.idParticipant.toString())
          .toList()
          .map((e) {
            e.pts = e.diff > 0
                ? 3
                : e.diff == 0
                    ? 1
                    : 0;
            e.nm = 1;
            e.nv = e.diff > 0 ? 1 : 0;
            e.nn = e.diff == 0 ? 1 : 0;
            e.nd = e.diff < 0 ? 1 : 0;
            e.res = e.diff > 0
                ? 'v'
                : e.diff == 0
                    ? 'n'
                    : 'd';
            return e;
          })
          .toList()
          .reduce((value, element) {
            value.pts += element.pts;
            value.nm += element.nm;
            value.nv += element.nv;
            value.nn += element.nn;
            value.nd += element.nd;
            value.diff += element.diff;
            value.bm += element.bm;
            value.be += element.be;
            value.res += element.res;
            return value;
          });
      data.add(stat);
    }

    return data;
  }
}
