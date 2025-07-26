import 'package:fscore/core/params/categorie/classement/classement_params.dart';
import 'package:fscore/models/game.dart';
import 'package:fscore/models/participation.dart';

abstract class ClasseurControllerRipository {
  final List<Game> games;
  final List<Participation> equipes;
  final ClassementParams? classements;
  const ClasseurControllerRipository(
      {required this.games, required this.equipes, this.classements});
  final List<String> criteresDefaut = const [
    "pts",
    "diff",
    "match",
    "bm",
    "be",
    "id"
  ];
}

abstract class ClasseurRipository extends ClasseurControllerRipository {
  final ClassementParams classements;
  const ClasseurRipository(
      {required super.games,
      required super.equipes,
      required this.classements});
}
