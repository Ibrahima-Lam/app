class Notif {
  String idNotif;
  String title;
  String content;
  String date;
  String? idGame;
  String? type;
  Notif({
    required this.idNotif,
    required this.title,
    required this.content,
    required this.date,
    this.idGame,
    this.type,
  });

  factory Notif.fromJson(Map<String, dynamic> json) => Notif(
        idNotif: json["idNotif"].toString(),
        title: json["title"],
        content: json["content"],
        date: json["date"],
        idGame: json["idGame"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "idNotif": idNotif,
        "title": title,
        "content": content,
        "date": date,
        "idGame": idGame,
        "type": type,
      };
}
