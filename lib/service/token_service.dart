import 'package:fscore/core/service/remote_service.dart';

class TokenService {
  static String collection = 'token';

  static Future<void> setToken(String token) async {
    if (token.isNotEmpty)
      await RemoteService.setData(collection, token, {'token': token});
  }

  static Future<List<String>> getTokens() async {
    return (await RemoteService.loadData(collection))
        .map((e) => e['token'].toString())
        .toList();
  }
}
