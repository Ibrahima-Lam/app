import 'package:fscore/collection/collection.dart';
import 'package:fscore/models/gameEvent.dart';

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
  getElementAt(String id) {}

  void add(GameEvent gameEvent) {
    _gameEvents.add(gameEvent);
  }
}
