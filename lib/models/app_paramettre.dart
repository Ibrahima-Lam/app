class AppParamettre {
  bool showUserName;
  AppParamettre({this.showUserName = true});

  factory AppParamettre.fromJson(Map<String, dynamic> json) =>
      AppParamettre(showUserName: json['showUserName'] ?? true);

  AppParamettre copyWith({bool? showUserName}) =>
      AppParamettre(showUserName: showUserName ?? this.showUserName);

  Map<String, dynamic> toJson() => {
        "showUserName": showUserName,
      };
}
