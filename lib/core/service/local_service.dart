import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class LocalService {
  final String _file;
  const LocalService(this._file);

  Future getData() async {
    if (kIsWeb) {
      return null; // Web does not support local file system access
    }
    final String? data = await _readData();
    if (data == null) return null;
    final json = jsonDecode(data);
    return json;
  }

  Future<void> setData(data) async {
    if (kIsWeb) {
      return; // Web does not support local file system access
    }
    _writeText(jsonEncode(data));
  }

  Future<String?> _readData() async {
    try {
      final file = await _getLocaleFile();
      return await file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Future<File> _writeText(String text) async {
    final file = await _getLocaleFile();
    return file.writeAsString(text);
  }

  Future<File> _getLocaleFile() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    return File('${dir.path}/$_file');
  }

  Future<bool> fileExists() async {
    return (await _getLocaleFile()).exists();
  }

  Future<DateTime?> lastModified() async {
    try {
      return (await _getLocaleFile()).lastModified();
    } catch (e) {
      return null;
    }
  }

  /* Future<File> create() async {
    return (await _getLocaleFile()).create();
  } */

  Future<bool> hasData() async {
    try {
      if (!await fileExists()) return false;
      if (await getData() == null) return false;
      if ((await getData())?.isEmpty ?? true) return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isLoadable([int max = 24]) async {
    try {
      if (!await hasData()) return false;
      DateTime? time = await lastModified();
      if (time == null) return false;
      int duration =
          DateTimeRange(start: time, end: DateTime.now()).duration.inHours;

      if (duration <= max) true;
      return false;
    } catch (e) {
      return false;
    }
  }
}
