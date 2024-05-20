extension DoubleExtension on double {
  int toPourcent() {
    if (this >= 0 && this <= 1) {
      return (this * 100).toInt();
    }
    throw Exception('Valeur no compris entre 0 et 1');
  }

  int toPourcentReverse() {
    if (this >= 0 && this <= 1) {
      return ((1 - this) * 100).toInt();
    }
    throw Exception('Valeur no compris entre 0 et 1');
  }

  String toPourcentString() {
    return this.toPourcent().toString() + '%';
  }

  static fromPourcent(double val) {
    return val / 100;
  }
}
