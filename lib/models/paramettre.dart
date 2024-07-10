class Paramettre {
  String idParamettre;
  String idEdition;
  List<String> users;
  bool showEvenement;
  bool showStatistique;
  bool showComposition;

  Paramettre(
      {required this.idParamettre,
      required this.idEdition,
      this.users = const [],
      this.showComposition = true,
      this.showEvenement = true,
      this.showStatistique = true});
}
