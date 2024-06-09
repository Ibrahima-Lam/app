import 'package:app/core/enums/event_type_enum.dart';
import 'package:app/models/event.dart';

class EquipeController {
  @Deprecated('implementer Abbreviable')
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

  static List<EventStatistique> getEventStistique(List<Event> events,
      {required EventType type}) {
    List<Event> data = [];
    List<EventStatistique> eventStatistiques = [];

    if (type == EventType.jaune)
      data = events
          .whereType<CardEvent>()
          .where((element) => !element.isRed)
          .toList();
    if (type == EventType.rouge)
      data = events
          .whereType<CardEvent>()
          .where((element) => element.isRed)
          .toList();
    if (type == EventType.but) data = events.whereType<GoalEvent>().toList();

    Set<String> joueurIds = data.map((e) => e.idJoueur).toSet();
    for (String id in joueurIds) {
      String nom = data.firstWhere((element) => element.idJoueur == id).nom;
      int nombre = data.fold(
          0,
          (previousValue, element) =>
              previousValue + (id == element.idJoueur ? 1 : 0));
      eventStatistiques
          .add(EventStatistique(nom: nom, nombre: nombre, id: id, type: type));
    }
    eventStatistiques.sort((a, b) => -(a.nombre - b.nombre));
    return eventStatistiques;
  }
}
