import 'dart:async';

import 'package:meta/meta.dart';
import 'package:re_seedwork/src/stores/base_store.dart';

/// ReadOnlyValueStore
abstract class ReadOnlyValueStore<T> implements BaseStore<T> {
  /// The current store value.
  T get data;
}

/// ValueStore
abstract class ValueStore<T> implements ReadOnlyValueStore<T> {
  /// Updates the state value.
  Future<bool> put(T value);
}

/// ValueStoreSink
abstract class ValueStoreSink<T> extends Stream<T>
    implements Sink<T>, ValueStore<T> {
  @protected
  @nonVirtual
  late T _value;

  @protected
  @nonVirtual
  @visibleForTesting
  final StreamController<T> controller;

  ValueStoreSink(
    T value,
  ) : controller = StreamController.broadcast() {
    _value = value;
  }

  @override
  @nonVirtual
  T get data {
    return _value;
  }

  @override
  @protected
  @nonVirtual
  bool add(T value) {
    if (controller.isClosed) {
      return false;
    }

    _value = value;
    controller.add(_value);

    return true;
  }

  @override
  @nonVirtual
  bool get isBroadcast {
    return controller.stream.isBroadcast;
  }

  @override
  @nonVirtual
  StreamSubscription<T> listen(
    void Function(T value)? onData, {
    Function? onError,
    bool? cancelOnError,
    void Function()? onDone,
  }) {
    return controller.stream.listen(
      onData,
      onDone: onDone,
      onError: onError,
      cancelOnError: cancelOnError,
    );
  }

  @override
  @nonVirtual
  Stream<T> asBroadcastStream({
    void Function(StreamSubscription<T> subscription)? onListen,
    void Function(StreamSubscription<T> subscription)? onCancel,
  }) {
    return controller.stream.asBroadcastStream(
      onListen: onListen,
      onCancel: onCancel,
    );
  }

  @override
  @nonVirtual
  bool get isClosed {
    return controller.isClosed;
  }

  @override
  @mustCallSuper
  Future<void> close() {
    return controller.close();
  }
}

/// InMemoryValueStore
class InMemoryValueStore<T> extends ValueStoreSink<T> {
  InMemoryValueStore(super.value);

  @override
  @nonVirtual
  bool get isPersistent {
    return false;
  }

  @override
  @mustCallSuper
  Future<bool> put(T value) async {
    return add(value);
  }
}
