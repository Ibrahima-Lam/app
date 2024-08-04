import 'package:app/controllers/competition/date.dart';
import 'package:app/models/composition.dart';
import 'package:app/service/local_service.dart';
import 'package:flutter/material.dart';

class CompositionService {
  static Future<List<Composition>> getCompositions() async {
    await Future.delayed(Duration(seconds: 1));
    return _toCompositions(strategies);
  }

  static Future<bool> addAllCompositions(
      String idGame, List<Composition> compos) async {
    if (strategies.any((element) => element['idGame'] == idGame)) return false;
    strategies.addAll(compos.map((e) => e.toJson()));
    return true;
  }

  static Future<bool> setAllCompositions(
      String idGame, List<Composition> compos) async {
    strategies.removeWhere((element) => element['idGame'] == idGame);
    strategies.addAll(compos.map((e) => e.toJson()));
    return true;
  }

  static Future<bool> setJoueurComposition(JoueurComposition composition,
      {required String idGame,
      required String idParticipant,
      required String idJoueur}) async {
    final bool Function(Composition) fn = (element) =>
        (element as JoueurComposition).idGame == idGame &&
        (element).idParticipant == idParticipant &&
        (element).idJoueur == idJoueur;
    final bool check = strategies.whereType<JoueurComposition>().any(fn);
    if (!check) return false;
    final int index = strategies.indexWhere(
      (element) {
        if (element is! JoueurComposition) return false;
        return fn(_toComposition(element));
      },
    );
    strategies[index] = composition.toJson();
    return true;
  }

  static LocalService get service => LocalService('composition.json');
  static List<Composition> _toCompositions(List data) {
    return data.map((e) => _toComposition(e)).toList();
  }

  static Composition _toComposition(Map<String, dynamic> data) {
    if (data['idJoueur'] != null) {
      return JoueurComposition.fromJson(data);
    } else if (data['idCoach'] != null) {
      return CoachComposition.fromJson(data);
    } else if (data['idArbitre'] != null) {
      return ArbitreComposition.fromJson(data);
    }
    return StaffComposition.fromJson(data);
  }

  static Future<List<Composition>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null) return _toCompositions(data);
    }
    return null;
  }

  static Future<List<Composition>> getData({bool remote = false}) async {
    final List<Composition> data = await getRemoteData();
    if (data.isEmpty && await service.hasData())
      return await getLocalData() ?? [];
    return data;
  }

  static Future<List<Composition>> getRemoteData() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (strategies.isNotEmpty) await service.setData(strategies);
      return _toCompositions(strategies);
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addComposition(Composition stat) async {
    strategies.add(stat.toJson());
    return true;
  }

  static Future<bool> editComposition(
      String idComposition, Composition stat) async {
    if (strategies
        .any((element) => element['idComposition'] == idComposition)) {
      int index = strategies
          .indexWhere((element) => element['idComposition'] == idComposition);
      if (index >= 0) strategies[index] = stat.toJson();
      return true;
    }
    return false;
  }

  static Future<bool> setComposition(
      String idComposition, Composition stat) async {
    if (strategies
        .any((element) => element['idComposition'] == idComposition)) {
      int index = strategies
          .indexWhere((element) => element['idComposition'] == idComposition);
      if (index >= 0) strategies[index] = stat.toJson();

      return true;
    }
    strategies.add(stat.toJson());
    return true;
  }

  static Future<bool> changeComposition(
      JoueurComposition sortant, JoueurComposition entrant,
      {required String idGame, required String idParticipant}) async {
    if (strategies.any((element) =>
            element['idJoueur'] == sortant.idJoueur &&
            element['idGame'] == idGame &&
            element['idParticipant'] == idParticipant) &&
        strategies.any((element) =>
            element['idJoueur'] == entrant.idJoueur &&
            element['idGame'] == idGame &&
            element['idParticipant'] == idParticipant)) {
      int indexS = strategies
          .indexWhere((element) => element['idJoueur'] == sortant.idJoueur);
      int indexE = strategies
          .indexWhere((element) => element['idJoueur'] == entrant.idJoueur);
      if (indexS >= 0 && indexE >= 0) {
        strategies[indexS]['entrant'] = entrant.idJoueur;
        strategies[indexE]['sortant'] = sortant.idJoueur;
      }
      return true;
    }
    return false;
  }

  static Future<bool> deleteComposition(String idComposition) async {
    if (strategies
        .any((element) => element['idComposition'] == idComposition)) {
      strategies
          .removeWhere((element) => element['idComposition'] == idComposition);
      return true;
    }
    return false;
  }
}

List<Map<String, dynamic>> strategies = [
  ...[
    {
      'idComposition': 'C1' + DateController.dateCollapsed,
      'idGame': '1',
      'isIn': true,
      'idParticipant': '25',
      'idJoueur': '35',
      'numero': 8,
      'nom': 'Abou Dia',
      'left': 160,
      'top': 730,
    },
    {
      'idComposition': 'C2' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '25',
      'idJoueur': '66',
      'numero': 4,
      'nom': 'Abou sy',
      'left': 300,
      'top': 630,
    },
    {
      'idComposition': 'C3' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '25',
      'idJoueur': '8',
      'numero': 5,
      'nom': 'Alsane Yall',
      'left': 206,
      'top': 650,
    },
    {
      'idComposition': 'C4' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '25',
      'idJoueur': '65',
      'numero': 12,
      'nom': 'Amadou Baidi',
      'left': 122,
      'top': 650,
    },
    {
      'idComposition': 'C5' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '25',
      'idJoueur': '6',
      'numero': 6,
      'nom': 'Amadou Dadde',
      'left': 20,
      'top': 630,
    },
    {
      'idComposition': 'C6' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '25',
      'idJoueur': '5',
      'numero': 10,
      'nom': 'Amadou cheikh',
      'left': 280,
      'top': 530,
    },
    {
      'idComposition': 'C7' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '25',
      'idJoueur': '38',
      'numero': 13,
      'nom': 'Hamodou',
      'jaune': 0,
      'left': 160,
      'top': 540,
    },
    {
      'idComposition': 'C8' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '25',
      'idJoueur': '7',
      'numero': 2,
      'nom': 'Lass lam',
      'left': 40,
      'top': 530,
    },
    {
      'idComposition': 'C9' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '25',
      'idJoueur': '36',
      'numero': 17,
      'nom': 'Mama Dia',
      'left': 280,
      'top': 420,
    },
    {
      'idComposition': 'C10' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '25',
      'idJoueur': '89',
      'numero': 3,
      'nom': 'Mamadou Mayi',
      'left': 160,
      'top': 430,
    },
    {
      'idComposition': 'C11' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '25',
      'idJoueur': '37',
      'numero': 11,
      'nom': 'Thierno Lamine',
      'left': 40,
      'top': 420,
    },
    {
      'idComposition': 'C12' + DateController.dateCollapsed,
      'isIn': false,
      'idGame': '1',
      'idParticipant': '25',
      'idJoueur': 'r01',
      'numero': 0,
      'nom': 'Remplacant',
      'left': 0,
      'top': 0,
    },
  ],
  ...[
    {
      'idComposition': 'C21' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '26',
      'idJoueur': '2',
      'numero': 1,
      'nom': 'Ablaye yall',
      'left': 160,
      'top': 730,
    },
    {
      'idComposition': 'C22' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '26',
      'idJoueur': '1',
      'numero': 10,
      'nom': 'El hadji syleimani',
      'left': 300,
      'top': 630,
    },
    {
      'idComposition': 'C23' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '26',
      'idJoueur': '3',
      'numero': 7,
      'nom': 'KaWo sy',
      'left': 206,
      'top': 650,
    },
    {
      'idComposition': 'C24' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '26',
      'idJoueur': '72',
      'numero': 18,
      'nom': 'Mahamodou',
      'left': 122,
      'top': 650,
    },
    {
      'idComposition': 'C25' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '26',
      'idJoueur': '74',
      'numero': 16,
      'nom': 'Nalla',
      'left': 20,
      'top': 630,
    },
    {
      'idComposition': 'C26' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '26',
      'idJoueur': '4',
      'numero': 9,
      'nom': 'Niga',
      'left': 280,
      'top': 530,
    },
    {
      'idComposition': 'C27' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '26',
      'idJoueur': '73',
      'numero': 11,
      'nom': 'Oumar amadou',
      'jaune': 0,
      'left': 160,
      'top': 540,
    },
    {
      'idComposition': 'C28' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '26',
      'idJoueur': 'joueur',
      'numero': 0,
      'nom': 'Player7',
      'left': 40,
      'top': 530,
    },
    {
      'idComposition': 'C29' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '26',
      'idJoueur': 'joueur',
      'numero': 0,
      'nom': 'Player8',
      'left': 280,
      'top': 420,
    },
    {
      'idComposition': 'C30' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '26',
      'idJoueur': 'joueur',
      'numero': 0,
      'nom': 'Player9',
      'left': 160,
      'top': 430,
    },
    {
      'idComposition': 'C31' + DateController.dateCollapsed,
      'isIn': true,
      'idGame': '1',
      'idParticipant': '26',
      'idJoueur': 'joueur',
      'numero': 0,
      'nom': 'Player10',
      'left': 40,
      'top': 420,
    },
    {
      'idComposition': 'C32' + DateController.dateCollapsed,
      'isIn': false,
      'idGame': '1',
      'idParticipant': '26',
      'idJoueur': 'r1',
      'numero': 0,
      'nom': 'Remplacant',
      'left': 0,
      'top': 0,
    }
  ],
  ...[
    {
      'idComposition': 'C40' + DateController.dateCollapsed,
      'idCoach': 'c1',
      'idParticipant': '25',
      'nom': 'Wagne',
      'idGame': '1',
      'jaune': 0,
      'rouge': 0,
    },
    {
      'idComposition': 'C41' + DateController.dateCollapsed,
      'idCoach': 'c2',
      'idParticipant': '26',
      'nom': 'Bathie',
      'idGame': '1',
      'jaune': 0,
      'rouge': 0,
    }
  ],
  ...[
    {
      'idComposition': 'C50' + DateController.dateCollapsed,
      'role': 'principale',
      'idArbitre': 'a1',
      'idGame': '1',
      'nom': 'Ibrahima Sy',
    },
    {
      'idComposition': 'C51' + DateController.dateCollapsed,
      'role': 'assistant',
      'idArbitre': 'a3',
      'idGame': '1',
      'nom': 'Aliseini Dia',
    },
    {
      'idComposition': 'C52' + DateController.dateCollapsed,
      'role': 'assistant',
      'idArbitre': 'a4',
      'idGame': '1',
      'nom': 'Saidou bocar',
    }
  ],
];

ValueNotifier<List<Composition>> compositions = ValueNotifier([
// home
  ...[
    JoueurComposition(
        idComposition: 'C1' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '25',
        idJoueur: '35',
        numero: 8,
        nom: 'Abou Dia',
        left: 160,
        top: 730),
    JoueurComposition(
        idComposition: 'C2' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '25',
        idJoueur: '66',
        numero: 4,
        nom: 'Abou sy',
        left: 300,
        top: 630),
    JoueurComposition(
        idComposition: 'C3' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '25',
        idJoueur: '8',
        numero: 5,
        nom: 'Alsane Yall',
        left: 206,
        top: 650),
    JoueurComposition(
        idComposition: 'C4' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '25',
        idJoueur: '65',
        numero: 12,
        nom: 'Amadou Baidi',
        left: 122,
        top: 650),
    JoueurComposition(
        idComposition: 'C5' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '25',
        idJoueur: '6',
        numero: 6,
        nom: 'Amadou Dadde',
        left: 20,
        top: 630),
    JoueurComposition(
        idComposition: 'C6' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '25',
        idJoueur: '5',
        numero: 10,
        nom: 'Amadou cheikh',
        left: 280,
        top: 530),
    JoueurComposition(
        idComposition: 'C7' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '25',
        idJoueur: '38',
        numero: 13,
        nom: 'Hamodou',
        jaune: 0,
        left: 160,
        top: 540),
    JoueurComposition(
        idComposition: 'C8' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '25',
        idJoueur: '7',
        numero: 2,
        nom: 'Lass lam',
        left: 40,
        top: 530),
    JoueurComposition(
        idComposition: 'C9' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '25',
        idJoueur: '36',
        numero: 17,
        nom: 'Mama Dia',
        left: 280,
        top: 420),
    JoueurComposition(
        idComposition: 'C10' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '25',
        idJoueur: '89',
        numero: 3,
        nom: 'Mamadou Mayi',
        left: 160,
        top: 430),
    JoueurComposition(
        idComposition: 'C11' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '25',
        idJoueur: '37',
        numero: 11,
        nom: 'Thierno Lamine',
        left: 40,
        top: 420),
  ],
  // away
  ...[
    JoueurComposition(
        idComposition: 'C1' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '26',
        idJoueur: '2',
        numero: 1,
        nom: 'Ablaye yall',
        left: 160,
        top: 730),
    JoueurComposition(
        idComposition: 'C2' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '26',
        idJoueur: '1',
        numero: 10,
        nom: 'El hadji syleimani',
        left: 300,
        top: 630),
    JoueurComposition(
        idComposition: 'C3' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '26',
        idJoueur: '3',
        numero: 7,
        nom: 'KaWo sy',
        left: 206,
        top: 650),
    JoueurComposition(
        idComposition: 'C4' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '26',
        idJoueur: '72',
        numero: 18,
        nom: 'Mahamodou',
        left: 122,
        top: 650),
    JoueurComposition(
        idComposition: 'C5' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '26',
        idJoueur: '74',
        numero: 16,
        nom: 'Nalla',
        left: 20,
        top: 630),
    JoueurComposition(
        idComposition: 'C6' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '26',
        idJoueur: '4',
        numero: 9,
        nom: 'Niga',
        left: 280,
        top: 530),
    JoueurComposition(
        idComposition: 'C7' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '26',
        idJoueur: '73',
        numero: 11,
        nom: 'Oumar amadou',
        jaune: 0,
        left: 160,
        top: 540),
    JoueurComposition(
        idComposition: 'C8' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '26',
        idJoueur: 'joueur',
        numero: 0,
        nom: 'Player7',
        left: 40,
        top: 530),
    JoueurComposition(
        idComposition: 'C9' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '26',
        idJoueur: 'joueur',
        numero: 0,
        nom: 'Player8',
        left: 280,
        top: 420),
    JoueurComposition(
        idComposition: 'C10' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '26',
        idJoueur: 'joueur',
        numero: 0,
        nom: 'Player9',
        left: 160,
        top: 430),
    JoueurComposition(
        idComposition: 'C11' + DateTime.now().millisecondsSinceEpoch.toString(),
        isIn: true,
        idGame: '1',
        idParticipant: '26',
        idJoueur: 'joueur',
        numero: 0,
        nom: 'Player10',
        left: 40,
        top: 420),
    // Coach
    ...[
      CoachComposition(
        idComposition: DateTime.now().millisecondsSinceEpoch.toString(),
        idCoach: 'c1',
        idParticipant: '25',
        nom: 'Wagne',
        idGame: '1',
        jaune: 0,
        rouge: 0,
      ),
      CoachComposition(
        idComposition: DateTime.now().millisecondsSinceEpoch.toString(),
        idCoach: 'c2',
        idParticipant: '26',
        nom: 'Bathie',
        idGame: '1',
        jaune: 0,
        rouge: 0,
      )
    ],
    ...[
      ArbitreComposition(
          role: 'principale',
          idArbitre: 'a1',
          idGame: '1',
          nom: 'Ibrahima Sy',
          idComposition: 'c1223'),
      ArbitreComposition(
          role: 'assistant',
          idArbitre: 'a3',
          idGame: '1',
          nom: 'Aliseini Dia',
          idComposition: 'c12564'),
      ArbitreComposition(
          role: 'assistant',
          idArbitre: 'a4',
          idGame: '1',
          nom: 'Saidou bocar',
          idComposition: 'c12556'),
    ]
  ]
]);
