import 'dart:convert';
import 'dart:io';

import 'package:app/models/app_paramettre.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class AppParamettreService {
  final String file_name = 'paramettre.json';

  Future<AppParamettre> getData() async {
    final json = jsonDecode(await _readData() ?? '{}');
    return AppParamettre.fromJson(json);
  }

  Future<void> setData(AppParamettre paramettre) async {
    _writeText(jsonEncode(paramettre.toJson()));
  }

  Future<String?> _readData() async {
    try {
      final file = await _getLocaleFile();
      return await file.readAsString();
    } catch (e) {
      print('erreur');
      return null;
    }
  }

  Future<File> _writeText(String text) async {
    final file = await _getLocaleFile();
    return file.writeAsString(text);
  }

  Future<File> _getLocaleFile() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    return File('${dir.path}/$file_name');
  }
}
