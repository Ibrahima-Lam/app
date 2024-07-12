enum GameEtat { annule, reporte, avant, direct, pause, arrete, termine }

class GameEtatClass {
  final String _text;
  const GameEtatClass(this._text);
  factory GameEtatClass.byEnum(GameEtat gameEtat) {
    return GameEtatClass(_fromEnum(gameEtat));
  }

  bool get started => etat.index > 2;

  String get text => _fromEnum(etat);
  GameEtat get etat => _toEnum(_text);

  static GameEtat _toEnum(String etat) {
    switch (etat.substring(0, 3).toUpperCase()) {
      case 'REP':
        return GameEtat.reporte;
      case 'DIR':
        return GameEtat.direct;
      case 'MI-':
        return GameEtat.pause;
      case 'PAU':
        return GameEtat.pause;
      case 'TER':
        return GameEtat.termine;
      case 'ANN':
        return GameEtat.annule;
      case 'ARR':
        return GameEtat.arrete;
      default:
        return GameEtat.avant;
    }
  }

  static String _fromEnum(GameEtat gameEtat) {
    switch (gameEtat) {
      case GameEtat.reporte:
        return 'Reporté';
      case GameEtat.direct:
        return 'Direct';
      case GameEtat.pause:
        return 'Mi-temps';
      case GameEtat.termine:
        return 'Terminé';
      case GameEtat.arrete:
        return 'Arreté';
      case GameEtat.annule:
        return 'Annulé';
      default:
        return 'Avant';
    }
  }
}
