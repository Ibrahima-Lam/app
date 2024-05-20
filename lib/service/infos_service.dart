import 'package:app/models/infos.dart';

class InfosService {
  static Future<List<Infos>> getData() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(
      20,
      (index) => Infos(
          id: index.toString(),
          text:
              'Hello this the content of the information after the breaking news. I hope you will understand it.'
              'That is speeking about competition and the teams also the players in their latest event ',
          title:
              'Title of the content $index also this is a part of the information!',
          datetime: DateTime.now().toString(),
          source: 'RMC sport'),
    );
  }
}
