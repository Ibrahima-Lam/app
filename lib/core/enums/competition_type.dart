enum CompetitionType { coupe, championnat, finale, amicale }

class CompetitionTypeClass {
  final String _text;
  const CompetitionTypeClass(this._text);
  factory CompetitionTypeClass.byEnum(CompetitionType CompetitionType) {
    return CompetitionTypeClass(_fromEnum(CompetitionType));
  }

  String get text => _fromEnum(type);
  CompetitionType get type => _toEnum(_text);

  static CompetitionType _toEnum(String type) {
    switch (type.substring(0, 3).toUpperCase()) {
      case 'COU':
        return CompetitionType.coupe;
      case 'CHA':
        return CompetitionType.championnat;
      case 'FIN':
        return CompetitionType.finale;

      default:
        return CompetitionType.amicale;
    }
  }

  static String _fromEnum(CompetitionType competitionType) {
    switch (competitionType) {
      case CompetitionType.coupe:
        return 'Coupe';
      case CompetitionType.championnat:
        return 'Championnat';
      case CompetitionType.finale:
        return 'Finale';

      default:
        return 'Amicale';
    }
  }
}
