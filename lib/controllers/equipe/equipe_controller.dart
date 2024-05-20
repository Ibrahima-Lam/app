class EquipeController {
  @Deprecated('implementer abbreviable')
  static String abbr(String text) {
    text = text.trim();
    if (text.substring(0, 2).toUpperCase() == 'FC') {
      text = text.substring(3).replaceAll('  ', ' ');
    }
    final List<String> liste = text.split(' ');

    final abbr = liste.length >= 2
        ? (liste[0].substring(0, 1) + liste[1].substring(0, 1)).toUpperCase()
        : liste[0].substring(0, 3);
    return abbr;
  }
}
