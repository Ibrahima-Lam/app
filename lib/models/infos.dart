class Infos {
  String id;
  String title;
  String text;
  String? source;
  String? image;
  String datetime;
  Infos({
    required this.id,
    required this.text,
    required this.title,
    required this.datetime,
    this.source,
    this.image = 'images/europa.jpg',
  });
}
