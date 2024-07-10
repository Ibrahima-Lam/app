import 'package:app/collection/collection.dart';
import 'package:app/models/competition.dart';

class CompetitionCollection implements Collection<Competition> {
  List<Competition> _competitions;
  CompetitionCollection(this._competitions);

  List<Competition> get competitions => _competitions;
  void set competitions(List<Competition> val) => _competitions = val;

  @override
  bool get isEmpty => _competitions.isEmpty;

  @override
  bool get isNotEmpty => _competitions.isNotEmpty;

  @override
  Competition getElementAt(String id) {
    return _competitions.firstWhere((element) => element.codeEdition == id);
  }
}
