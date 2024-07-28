import 'package:flutter/material.dart';

class DateController {
  static String get dateCollapsed => DateTime.now()
      .toString()
      .replaceAll(' ', '')
      .replaceAll(':', '')
      .replaceAll('-', '')
      .substring(0, 14);
  /**
   * retourne une liste de date ou les temps
   */
  static List<String?> frDates(List<String> dates) {
    return dates.map((e) {
      return frDate(e, abbr: true);
    }).toList();
  }

/**
 * Retourne une date en francais ou les temps
 */
  static String frDate(String? dateString,
      {bool abbr = false, bool year = false}) {
    if (dateString == null || dateString.isEmpty) {
      return 'Date inconnue';
    }
    final String date = DateTime.now().toString().substring(0, 10);
    final String demain =
        DateTime.now().add(const Duration(days: 1)).toString().substring(0, 10);
    final String hier = DateTime.now()
        .add(const Duration(days: -1))
        .toString()
        .substring(0, 10);
    if (dateString == date) {
      return "Aujourd'hui";
    }
    if (dateString == demain) {
      return "Demain";
    }
    if (dateString == hier) {
      return "Hier";
    } else {
      return abbr
          ? abbrDate(dateString, year: year)
          : fullDate(dateString, year: year);
    }
  }

/**
 * retourne une date abbregée avec ou sans l'année
 */
  static String abbrDate(String? date, {bool year = false}) {
    if (date == null) {
      return 'Date inconnue';
    }
    try {
      final dt = DateTime.parse(date);

      final String abbrday = '${semaine[dt.weekday - 1].substring(0, 3)}.';

      String abbrmonth =
          '${mois[dt.month - 1].substring(0, mois[dt.month - 1].length > 4 ? 4 : null)}.';

      if (mois[dt.month - 1].length <= 5) {
        abbrmonth = mois[dt.month - 1];
      }

      return '$abbrday ${dt.day} $abbrmonth ${year ? dt.year : ''}';
    } catch (e) {
      return 'Date inconnue';
    }
  }

/**
 * retourne une date en tout avec ou sans l'année
 */
  static String fullDate(String? date, {bool year = false}) {
    if (date == null || date.isEmpty) {
      return 'Date inconnue';
    }
    final dt = DateTime.parse(date);
    return '${semaine[dt.weekday - 1]} ${dt.day} ${mois[dt.month - 1]} ${year ? dt.year : ''}';
  }

  /**
   * retourne une duree 
   */
  static String frDateTime(String datetime, {int level = 7}) {
    final DateTime date = DateTime.parse(datetime);
    final DateTime now = DateTime.now();

    if (datetime.compareTo(now.toString()) > 0) {
      return abbrDate(datetime);
    }

    final range = DateTimeRange(start: date, end: now);
    if (range.duration.inSeconds <= 1 && level >= 1) {
      return 'à l\'instant';
    }
    if (range.duration.inMinutes < 1 && level >= 2) {
      return 'il y\'a ${range.duration.inSeconds} secondes';
    }
    if (range.duration.inHours < 1 && level >= 3) {
      final int value = range.duration.inMinutes;
      return 'il y\'a ${value} minute${value > 1 ? 's' : ''}';
    }
    if (range.duration.inDays < 1 && level >= 4) {
      final int value = range.duration.inHours;
      return 'il y\'a ${value} heure${value > 1 ? 's' : ''}';
    }
    if (range.duration.inDays < 30 && level >= 5) {
      final int value = range.duration.inDays;
      return 'il y\'a ${value} jour${value > 1 ? 's' : ''}';
    }
    if (range.duration.inDays < 365 && level >= 6) {
      return 'il y\'a ${range.duration.inDays ~/ 30} mois';
    }
    if (range.duration.inDays >= 365 && level >= 7) {
      final int value = range.duration.inDays ~/ 365;
      return 'il y\'a ${value} an${value > 1 ? 's' : ''}';
    }
    return abbrDate(datetime);
  }
}

List<String> semaine = [
  "Lundi",
  "Mardi",
  "Mercredi",
  "Jeudi",
  "Vendredi",
  "Samedi",
  "Dimanche",
];
List<String> mois = [
  "Janvier",
  "Février",
  "Mars",
  "Avril",
  "Mai",
  "Juin",
  "Juillet",
  "Aout",
  "Septembre",
  "Octobre",
  "Novembre",
  "Descembre"
];
