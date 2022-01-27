extension ListExtension<T> on List<T> {
  Iterable<T> divideBy(T divider) sync* {
    final _iterator = iterator;
    final isNotEmpty = _iterator.moveNext();
    if (!isNotEmpty) return;

    var tile = _iterator.current;
    while (_iterator.moveNext()) {
      yield tile;
      yield divider;
      tile = _iterator.current;
    }
    if (isNotEmpty) yield tile;
  }
}
