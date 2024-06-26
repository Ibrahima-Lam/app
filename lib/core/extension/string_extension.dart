extension StringExtension on String {
  String capitalize() {
    final String first = this.substring(0, 1).toUpperCase();
    final String last = this.substring(1);
    return first + last;
  }

  int toInt() {
    return double.parse(this).toInt();
  }
}
