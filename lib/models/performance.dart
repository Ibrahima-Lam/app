import 'package:app/core/enums/performance_type.dart';
import 'package:app/models/game.dart';

class Performance {
  String id;
  String nom;
  PerformanceType type;
  int nombre;

  Performance({
    required this.id,
    required this.nom,
    required this.type,
    required this.nombre,
  });

  String get title {
    if (type == PerformanceType.but) {
      return switch (nombre) {
        1 => 'but',
        2 => 'doublé',
        3 => 'triplé',
        4 => 'quadruplé',
        5 => 'quintuplé',
        int() => '${nombre} buts marqués',
      };
    }
    if (type == PerformanceType.passe) {
      return 'passes decisives';
    }
    return '';
  }
}

class GamePerformances {
  Game game;
  List<Performance> performances;
  GamePerformances({required this.game, required this.performances});
}
