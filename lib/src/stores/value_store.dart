import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

/// {@template state.StoreBase}
/// An interface for the core functionality implemented by stores.
/// {@endtemplate}
abstract class StoreBase<T> implements StateStreamableSource<T> {
  /// Whether this storage is persistent or not.
  bool get isPersistent;

  @override
  Future<void> close();
}

/// {@template state.ValueStoreSink}
/// A base interface for single value streamable store.
/// {@endtemplate}
abstract class ValueStoreSink<T> implements StoreBase<T> {
  /// Updates store state.
  Future<void> put(final T state);
}

/// {@template state.InMemoryValueStore}
/// A simple in-memory implementation of the [ValueStoreSink].
/// {@endtemplate}
class InMemoryValueStore<T> implements ValueStoreSink<T>, Sink<T> {
  @protected
  @nonVirtual
  T _state;

  @nonVirtual
  @visibleForTesting
  final StreamController<T> controller;

  /// {@macro state.InMemoryValueStore}
  InMemoryValueStore(
    this._state,
  ) : controller = StreamController.broadcast();

  @override
  T get state {
    return _state;
  }

  @override
  Stream<T> get stream {
    return controller.stream;
  }

  @override
  bool get isPersistent {
    return false;
  }

  @override
  bool get isClosed {
    return controller.isClosed;
  }

  @override
  @mustCallSuper
  Future<void> put(T state) async {
    add(state);
  }

  @override
  @protected
  @nonVirtual
  void add(T data) {
    if (isClosed) return;
    if (_state == data) return;

    _state = data;
    controller.add(data);
  }

  @override
  Future<void> close() {
    return controller.close();
  }
}
