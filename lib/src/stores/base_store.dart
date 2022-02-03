import 'dart:async';

/// Store
abstract class BaseStore<T> implements Stream<T> {
  /// Whether this storage is a broadcast stream.
  @override
  bool get isBroadcast;

  /// Whether this storage is persistent or not.
  bool get isPersistent;

  /// Whether this storage is closed.
  bool get isClosed;

  /// Closes the storage.
  Future<void> close();
}
