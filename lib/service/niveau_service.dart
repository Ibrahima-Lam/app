import 'dart:async';

import 'package:app/models/niveau.dart';

class NiveauService {
  static FutureOr<List<Niveau>> getNiveaux() async =>
      niveaux.map((e) => Niveau.fromJson(e)).toList();
}

const List<Map<String, dynamic>> niveaux = [
  {
    "codeNiveau": "tr1",
    "nomNiveau": "tour 1",
    "typeNiveau": "groupe",
    "ordreNiveau": "a1tr1"
  },
  {
    "codeNiveau": "tr2",
    "nomNiveau": "tour 2",
    "typeNiveau": "groupe",
    "ordreNiveau": "a2tr2"
  },
  {
    "codeNiveau": "tr3",
    "nomNiveau": "tour 3",
    "typeNiveau": "groupe",
    "ordreNiveau": "a3tr3"
  },
  {
    "codeNiveau": "tr4",
    "nomNiveau": "tour 4",
    "typeNiveau": "groupe",
    "ordreNiveau": "a4tr4"
  },
  {
    "codeNiveau": "tr",
    "nomNiveau": "match de Groupe",
    "typeNiveau": "groupe",
    "ordreNiveau": "atr"
  },
  {
    "codeNiveau": "qf",
    "nomNiveau": "Quart de Final",
    "typeNiveau": "elimination",
    "ordreNiveau": "b4qf"
  },
  {
    "codeNiveau": "df",
    "nomNiveau": "Demi-finale",
    "typeNiveau": "elimination",
    "ordreNiveau": "b5df"
  },
  {
    "codeNiveau": "fn",
    "nomNiveau": "Finale",
    "typeNiveau": "elimination",
    "ordreNiveau": "b7fn"
  },
  {
    "codeNiveau": "pf",
    "nomNiveau": "Troisiéme place",
    "typeNiveau": "elimination",
    "ordreNiveau": "b6pf"
  },
  {
    "codeNiveau": "jrn1",
    "nomNiveau": "Journ\u00e9e 1",
    "typeNiveau": "championnat",
    "ordreNiveau": "c1jrn1"
  },
  {
    "codeNiveau": "jrn2",
    "nomNiveau": "Journ\u00e9e 2",
    "typeNiveau": "championnat",
    "ordreNiveau": "c2jrn2"
  },
  {
    "codeNiveau": "jrn3",
    "nomNiveau": "Journ\u00e9e 3",
    "typeNiveau": "championnat",
    "ordreNiveau": "c3jrn3"
  },
  {
    "codeNiveau": "jrn4",
    "nomNiveau": "Journ\u00e9e 4",
    "typeNiveau": "championnat",
    "ordreNiveau": "c4jrn4"
  },
  {
    "codeNiveau": "jrn5",
    "nomNiveau": "Journ\u00e9e 5",
    "typeNiveau": "championnat",
    "ordreNiveau": "c5jrn5"
  },
  {
    "codeNiveau": "jrn6",
    "nomNiveau": "Journ\u00e9e 6",
    "typeNiveau": "championnat",
    "ordreNiveau": "c6jrn6"
  },
  {
    "codeNiveau": "jrn7",
    "nomNiveau": "Journ\u00e9e 7",
    "typeNiveau": "championnat",
    "ordreNiveau": "c7jrn7"
  },
  {
    "codeNiveau": "jrn8",
    "nomNiveau": "Journ\u00e9e 8",
    "typeNiveau": "championnat",
    "ordreNiveau": "c8jrn8"
  },
  {
    "codeNiveau": "jrn9",
    "nomNiveau": "Journ\u00e9e 9",
    "typeNiveau": "championnat",
    "ordreNiveau": "c9jrn9"
  },
  {
    "codeNiveau": "jrn10",
    "nomNiveau": "Journ\u00e9e 10",
    "typeNiveau": "championnat",
    "ordreNiveau": "c10jrn10"
  },
  {
    "codeNiveau": "jrn11",
    "nomNiveau": "Journ\u00e9e 11",
    "typeNiveau": "championnat",
    "ordreNiveau": "c11jrn11"
  },
  {
    "codeNiveau": "jrn12",
    "nomNiveau": "Journ\u00e9e 12",
    "typeNiveau": "championnat",
    "ordreNiveau": "c12jrn12"
  },
  {
    "codeNiveau": "jrn13",
    "nomNiveau": "Journ\u00e9e 13",
    "typeNiveau": "championnat",
    "ordreNiveau": "c13jrn13"
  },
  {
    "codeNiveau": "jrn14",
    "nomNiveau": "Journ\u00e9e 14",
    "typeNiveau": "championnat",
    "ordreNiveau": "c14jrn14"
  },
  {
    "codeNiveau": "jrn15",
    "nomNiveau": "Journ\u00e9e 15",
    "typeNiveau": "championnat",
    "ordreNiveau": "c15jrn15"
  },
  {
    "codeNiveau": "jrn16",
    "nomNiveau": "Journ\u00e9e 16",
    "typeNiveau": "championnat",
    "ordreNiveau": "c16jrn16"
  },
  {
    "codeNiveau": "jrn17",
    "nomNiveau": "Journ\u00e9e 17",
    "typeNiveau": "championnat",
    "ordreNiveau": "c17jrn17"
  },
  {
    "codeNiveau": "jrn18",
    "nomNiveau": "Journ\u00e9e 18",
    "typeNiveau": "championnat",
    "ordreNiveau": "c18jrn18"
  },
  {
    "codeNiveau": "jrn19",
    "nomNiveau": "Journ\u00e9e 19",
    "typeNiveau": "championnat",
    "ordreNiveau": "c19jrn19"
  },
  {
    "codeNiveau": "jrn20",
    "nomNiveau": "Journ\u00e9e 20",
    "typeNiveau": "championnat",
    "ordreNiveau": "c20jrn20"
  },
  {
    "codeNiveau": "jrn21",
    "nomNiveau": "Journ\u00e9e 21",
    "typeNiveau": "championnat",
    "ordreNiveau": "c21jrn21"
  },
  {
    "codeNiveau": "jrn22",
    "nomNiveau": "Journ\u00e9e 22",
    "typeNiveau": "championnat",
    "ordreNiveau": "c22jrn22"
  },
  {
    "codeNiveau": "jrn23",
    "nomNiveau": "Journ\u00e9e 23",
    "typeNiveau": "championnat",
    "ordreNiveau": "c23jrn23"
  },
  {
    "codeNiveau": "jrn24",
    "nomNiveau": "Journ\u00e9e 24",
    "typeNiveau": "championnat",
    "ordreNiveau": "c24jrn24"
  },
  {
    "codeNiveau": "jrn25",
    "nomNiveau": "Journ\u00e9e 25",
    "typeNiveau": "championnat",
    "ordreNiveau": "c25jrn25"
  },
  {
    "codeNiveau": "jrn26",
    "nomNiveau": "Journ\u00e9e 26",
    "typeNiveau": "championnat",
    "ordreNiveau": "c26jrn26"
  },
  {
    "codeNiveau": "jrn27",
    "nomNiveau": "Journ\u00e9e 27",
    "typeNiveau": "championnat",
    "ordreNiveau": "c27jrn27"
  },
  {
    "codeNiveau": "jrn28",
    "nomNiveau": "Journ\u00e9e 28",
    "typeNiveau": "championnat",
    "ordreNiveau": "c28jrn28"
  },
  {
    "codeNiveau": "jrn29",
    "nomNiveau": "Journ\u00e9e 29",
    "typeNiveau": "championnat",
    "ordreNiveau": "c29jrn29"
  },
  {
    "codeNiveau": "jrn30",
    "nomNiveau": "Journ\u00e9e 30",
    "typeNiveau": "championnat",
    "ordreNiveau": "c30jrn30"
  },
  {
    "codeNiveau": "jrn31",
    "nomNiveau": "Journ\u00e9e 31",
    "typeNiveau": "championnat",
    "ordreNiveau": "c31jrn31"
  },
  {
    "codeNiveau": "jrn32",
    "nomNiveau": "Journ\u00e9e 32",
    "typeNiveau": "championnat",
    "ordreNiveau": "c32jrn32"
  },
  {
    "codeNiveau": "jrn33",
    "nomNiveau": "Journ\u00e9e 33",
    "typeNiveau": "championnat",
    "ordreNiveau": "c33jrn33"
  },
  {
    "codeNiveau": "jrn34",
    "nomNiveau": "Journ\u00e9e 34",
    "typeNiveau": "championnat",
    "ordreNiveau": "c34jrn34"
  },
  {
    "codeNiveau": "jrn35",
    "nomNiveau": "Journ\u00e9e 35",
    "typeNiveau": "championnat",
    "ordreNiveau": "c35jrn35"
  },
  {
    "codeNiveau": "jrn36",
    "nomNiveau": "Journ\u00e9e 36",
    "typeNiveau": "championnat",
    "ordreNiveau": "c36jrn36"
  },
  {
    "codeNiveau": "jrn37",
    "nomNiveau": "Journ\u00e9e 37",
    "typeNiveau": "championnat",
    "ordreNiveau": "c37jrn37"
  },
  {
    "codeNiveau": "jrn38",
    "nomNiveau": "Journ\u00e9e 38",
    "typeNiveau": "championnat",
    "ordreNiveau": "c38jrn38"
  }
];
