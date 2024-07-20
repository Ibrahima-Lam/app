import 'package:app/models/paramettre.dart';
import 'package:flutter/material.dart';

class ParamettreService {
  static Future<List<Paramettre>> getData() async {
    await Future.delayed(Durations.extralong4);
    return [
      Paramettre(
        idParamettre: 'p1',
        idEdition: 'thialgou2023',
        qualifs: 4,
        users: ['ibrahimaaboulam@gmail.com', 'root@gmail.com'],
      ),
      Paramettre(
        idParamettre: 'p2',
        idEdition: 'district2023',
        qualifs: 16,
        users: ['amadoulam@gmail.com', 'root@gmail.com'],
      ),
    ];
  }
}
