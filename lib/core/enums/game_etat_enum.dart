enum GameEtat { annule, reporte, avant, direct, pause, termine }

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
      case 'TER':
        return GameEtat.termine;
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
      default:
        return 'Avant';
    }
  }
}
