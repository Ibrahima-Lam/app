extension IntExtension on int {
  int get positiveOrZero {
    return this >= 0 ? this : 0;
  }

  String toStringMinLengh(int length) {
    if (this.toString().length >= length) return this.toString();
    return '0' * (length - this.toString().length) + this.toString();
  }
}
