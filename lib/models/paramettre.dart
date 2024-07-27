class Paramettre {
  String idParamettre;
  String idEdition;
  List<String> users;
  bool showEvenement;
  bool showStatistique;
  bool showComposition;
  int? success;

  Paramettre({
    required this.idParamettre,
    required this.idEdition,
    this.users = const [],
    this.showComposition = false,
    this.showEvenement = true,
    this.showStatistique = true,
    this.success,
  });

  factory Paramettre.fromJson(Map<String, dynamic> json) {
    return Paramettre(
      idParamettre: json['idParamettre'],
      idEdition: json['idEdition'],
      users: json['users'].split(','),
      showComposition: json['showComposition'] ?? false,
      showEvenement: json['showEvenement'] ?? true,
      showStatistique: json['showStatistique'] ?? true,
      success: json['success'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() => {
        'idParamettre': idParamettre,
        'idEdition': idEdition,
        'users': users.join(','),
        'showComposition': showComposition,
        'showEvenement': showEvenement,
        'showStatistique': showStatistique,
        'success': success,
      };
}
