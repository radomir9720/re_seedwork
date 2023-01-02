extension DivideIterableExtension<T> on Iterable<T> {
  Iterable<T> divideBy(T divider) sync* {
    // ignore: no_leading_underscores_for_local_identifiers
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
