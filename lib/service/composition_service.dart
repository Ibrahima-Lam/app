import 'package:app/models/composition.dart';
import 'package:app/service/local_service.dart';
import 'package:flutter/material.dart';

class CompositionService {
  static Future<List<Composition>> getCompositions() async {
    await Future.delayed(Duration(seconds: 1));
    return compositions.value;
  }

  static Future<void> setCompositions(
      String idGame, List<Composition> compos) async {
    final List<Composition> data = compositions.value
        .where((element) => element.idGame != idGame)
        .toList();
    data.addAll(compos);
    compositions.value = data;
  }

  static Future<void> setJoueurComposition(JoueurComposition composition,
      {required String idGame,
      required String idParticipant,
      required String idJoueur}) async {
    final bool Function(Composition) fn = (element) =>
        (element as JoueurComposition).idGame == idGame &&
        (element).idParticipant == idParticipant &&
        (element).idJoueur == idJoueur;
    final bool check =
        compositions.value.whereType<JoueurComposition>().any(fn);
    if (!check) return;
    final int index = compositions.value.indexWhere(
      (element) {
        if (element is! JoueurComposition) return false;
        return fn(element);
      },
    );
    compositions.value[index] = composition;
  }

  static LocalService get service => LocalService('composition.json');
  static List<Composition> _toComposition(List data) {
    return data.map((e) {
      if (e['idJoueur'] != null) {
        return JoueurComposition.fromJson(e);
      } else if (e['idCoach'] != null) {
        return CoachComposition.fromJson(e);
      } else if (e['idArbitre'] != null) {
        return ArbitreComposition.fromJson(e);
      }
      return StaffComposition.fromJson(e);
    }).toList();
  }

  static Future<List<Composition>?> getLocalData() async {
    if (await service.fileExists()) {
      final List? data = (await service.getData());
      if (data != null) return _toComposition(data);
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
      if (compositions.value.isNotEmpty)
        await service.setData(compositions.value);
      return compositions.value;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addComposition(Composition stat) async {
    compositions.value.add(stat);
    return true;
  }

  static Future<bool> editComposition(
      String idComposition, Composition stat) async {
    if (compositions.value
        .any((element) => element.idComposition == idComposition)) {
      int index = compositions.value
          .indexWhere((element) => element.idComposition == idComposition);
      if (index >= 0) compositions.value[index] = stat;
      return true;
    }
    return false;
  }

  static Future<bool> deleteComposition(String idComposition) async {
    if (compositions.value
        .any((element) => element.idComposition == idComposition)) {
      compositions.value
          .removeWhere((element) => element.idComposition == idComposition);
      return true;
    }
    return true;
  }
}

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
