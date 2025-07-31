import 'dart:convert';
import 'dart:developer';

import 'package:fscore/models/api/fixture.dart';

import 'package:http/http.dart' as http;

class FixtureService {
  FixtureService();

  final headers = {
    'x-rapidapi-key': '16e409cab4da3f909016304a1d97016e',
    'x-rapidapi-host': 'v3.football.api-sports.io'
  };

  Future<List<Fixture>> getFixtures({
    required String date,
  }) async {
    try {
      var request = http.Request('GET',
          Uri.parse("https://v3.football.api-sports.io/fixtures?date=$date"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final data =
            jsonDecode(await response.stream.bytesToString())['response']
                as List;
        List<Fixture> res = data.map((e) => Fixture.fromJson(e)).toList();
        log(res.length.toString());
        return res;
      } else {
        print(response.reasonPhrase);
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<Fixture>> getLiveFixtures() async {
    try {
      var request = http.Request('GET',
          Uri.parse("https://v3.football.api-sports.io/fixtures?live=all"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final data =
            jsonDecode(await response.stream.bytesToString())['response']
                as List;
        List<Fixture> res = data.map((e) => Fixture.fromJson(e)).toList();
        log(res.length.toString());
        return res;
      } else {
        print(response.reasonPhrase);
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
