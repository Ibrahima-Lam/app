import 'package:app/collection/collection.dart';
import 'package:app/models/gameEvent.dart';

class GameEventCollection implements Collection {
  List<GameEvent> _gameEvents;
  GameEventCollection(this._gameEvents);

  @override
  bool get isEmpty => _gameEvents.isEmpty;

  @override
  bool get isNotEmpty => _gameEvents.isNotEmpty;

  void set gameEvents(List<GameEvent> val) => _gameEvents = val;
  List<GameEvent> get gameEvents => _gameEvents;

  @override
  GameEvent? getElementAt(String id) {
    final List<GameEvent> list =
        _gameEvents.where((element) => element.idGame == id).toList();
    return list.isNotEmpty ? list[0] : null;
  }

  void add(GameEvent gameEvent) {
    _gameEvents.add(gameEvent);
  }
}
