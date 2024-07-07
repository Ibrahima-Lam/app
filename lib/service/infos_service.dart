import 'package:app/models/infos/infos.dart';

class InfosService {
  static Stream<Infos> getData() async* {
    await Future.delayed(const Duration(seconds: 1));
    List<Infos> infos = List.generate(
      20,
      (index) => Infos(
        id: index.toString(),
        text:
            'Hello this the content of the information after the breaking news. I hope you will understand it.'
            'That is speeking about competition and the teams also the players in their latest event ',
        title:
            'Title of the content $index also this is a part of the information!',
        datetime: DateTime.now().toString(),
        source: 'RMC sport',
      ),
    );
    for (var info in infos) {
      await Future.delayed(const Duration(seconds: 1));
      yield info;
    }
  }
}
