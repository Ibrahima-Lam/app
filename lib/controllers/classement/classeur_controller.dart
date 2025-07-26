import 'package:fscore/controllers/classement/classeur_ripository.dart';
import 'package:fscore/core/enums/enums.dart';
import 'package:fscore/core/enums/game_etat_enum.dart';
import 'package:fscore/core/extension/list_extension.dart';
import 'package:fscore/models/game.dart';
import 'package:fscore/models/participation.dart';
import 'package:fscore/models/stat.dart';

class ClasseurController extends ClasseurControllerRipository {
  const ClasseurController(
      {required super.games,
      required super.equipes,
      required super.classements});

  List<Stat> classe({
    List<String>? criteres,
    int Function(Stat, Stat)? callback,
    List<Stat>? allStat,
  }) {
    List<Stat> stats = teamStat(teamGamesStat());
    stats.sort((a, b) {
      return sorter(a, b,
          criteres: criteres ?? criteresDefaut, callback: callback);
    });
    for (int i = 0; i < stats.length; i++) {
      stats[i].num = i + 1;
      stats[i].playing = isPlaying(stats[i].id);
      if (allStat != null) {
        Stat? stat =
            allStat.singleWhereOrNull((element) => element.id == stats[i].id);
        if (stat != null && (classements?.total ?? 0) > 0) {
          stats[i].position = stat.position;

          if (classements == null) continue;

          int level = (classements?.success ?? 0);
          if (stat.position! <= level) {
            stats[i].level = ClassementType.success;
            continue;
          }
          level += (classements?.primary ?? 0);
          if (stat.position! <= level) {
            stats[i].level = ClassementType.primary;
            continue;
          }
          level += (classements?.infos ?? 0);
          if (stat.position! <= level) {
            stats[i].level = ClassementType.infos;
            continue;
          }
          level += (classements?.warnning ?? 0);
          if (stat.position! <= level) {
            stats[i].level = ClassementType.warnning;
            continue;
          }
          level += (classements?.orange ?? 0);
          if (stat.position! <= level) {
            stats[i].level = ClassementType.warnning;
            continue;
          }
          level += (classements?.defaults ?? 0);
          if (stat.position! <= level) {
            stats[i].level = ClassementType.defaults;
            continue;
          }
          level += (classements?.danger ?? 0);
          if (stat.position! >= level) {
            stats[i].level = ClassementType.danger;
            continue;
          }
        }
      }
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
      {required List<String> criteres,
      int Function(Stat, Stat)? callback,
      bool standard = false}) {
    for (String key in criteres) {
      if (key == 'match' && !standard) {
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
          if (a.toJson()[key] is int && b.toJson()[key] is int) {
            return a.toJson()[key] - b.toJson()[key];
          }
          return a
              .toJson()[key]
              .toString()
              .compareTo(b.toJson()[key].toString());
        }
        if (a.toJson()[key] is int && b.toJson()[key] is int) {
          return b.toJson()[key] - a.toJson()[key];
        }
        return b.toJson()[key].toString().compareTo(a.toJson()[key].toString());
      }
    }
    return 0;
  }

  int confrontation(Stat a, Stat b) {
    if (games.isEmpty) return 0;
    List<Game> matchs = games
        .where((game) =>
            game.idHome == a.id && game.idAway == b.id ||
            game.idAway == a.id && game.idHome == b.id)
        .toList();
    if (matchs.length > 2) return 0;
    int homebut = 0;
    int awaybut = 0;
    if (matchs.length == 2) {
      Game aller = matchs[0];
      Game retour = matchs[1];
      if (aller.idHome == b.id) {
        homebut += (aller.score?.homeScore ?? 0);
        awaybut += (aller.score?.awayScore ?? 0);
      } else {
        homebut += (aller.score?.awayScore ?? 0);
        awaybut += (aller.score?.homeScore ?? 0);
      }
      if (retour.idHome == b.id) {
        homebut += (retour.score?.homeScore ?? 0);
        awaybut += (retour.score?.awayScore ?? 0);
      } else {
        homebut += (retour.score?.awayScore ?? 0);
        awaybut += (retour.score?.homeScore ?? 0);
      }
      return homebut - awaybut;
    }

    if (matchs.isNotEmpty) {
      Game match = matchs[0];
      int diff = (match.idHome == b.id)
          ? (match.score?.homeScore ?? 0) - (match.score?.awayScore ?? 0)
          : -((match.score?.homeScore ?? 0) - (match.score?.awayScore ?? 0));
      return diff;
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
    elements.sort((a, b) => (a.date ?? '').compareTo(b.date ?? ''));
    return elements;
  }

  List<Stat> teamStat(List<Stat> stats) {
    List<Stat> data = [];
    for (Participation equipe in equipes) {
      List<Stat> statistique = stats
          .where((statElement) =>
              statElement.id == equipe.idParticipant.toString())
          .toList();
      if (statistique.isEmpty) {
        data.add(Stat(
          id: equipe.idParticipant,
          nom: equipe.participant.nomEquipe,
          bm: 0,
          be: 0,
          diff: 0,
          nm: 0,
          nv: 0,
          nn: 0,
          nd: 0,
          res: '',
          imageUrl: equipe.participant.imageUrl,
        ));
        continue;
      }
      Stat stat = statistique
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
