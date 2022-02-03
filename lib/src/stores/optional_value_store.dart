import 'dart:async';

import 'package:meta/meta.dart';
import 'package:re_seedwork/src/stores/base_store.dart';
import 'package:re_seedwork/src/values/optional.dart';

/// ReadOnlyValueStore
abstract class ReadOnlyOptionalValueStore<T extends Object>
    implements BaseStore<Optional<T>> {
  /// The current store value.
  T? get value;

  /// The current store value.
  Optional<T> get data;
}

/// ValueStore
abstract class OptionalValueStore<T extends Object>
    implements ReadOnlyOptionalValueStore<T> {
  /// Flushs any stored data.
  Future<bool> flush();

  /// Updates the state value.
  Future<bool> put(T value);
}

/// OptionalValueStoreSink
abstract class OptionalValueStoreSink<T extends Object>
    extends Stream<Optional<T>>
    implements Sink<Optional<T>>, OptionalValueStore<T> {
  @protected
  @nonVirtual
  late Optional<T> _value;

  @protected
  @nonVirtual
  @visibleForTesting
  final StreamController<Optional<T>> controller;

  OptionalValueStoreSink([
    T? value,
  ]) : controller = StreamController.broadcast() {
    _value = Optional<T>(value);
  }

  @override
  @nonVirtual
  Optional<T> get data {
    return _value;
  }

  @override
  @nonVirtual
  T? get value {
    return data.when(
      undefined: () => null,
      presented: (value) => value,
    );
  }

  @override
  @protected
  @nonVirtual
  bool add(Optional<T> value) {
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
  StreamSubscription<Optional<T>> listen(
    void Function(Optional<T> value)? onData, {
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
  Stream<Optional<T>> asBroadcastStream({
    void Function(StreamSubscription<Optional<T>> subscription)? onListen,
    void Function(StreamSubscription<Optional<T>> subscription)? onCancel,
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

/// InMemoryOptionalValueStore
class InMemoryOptionalValueStore<T extends Object>
    extends OptionalValueStoreSink<T> {
  InMemoryOptionalValueStore([
    T? value,
  ]) : super(value);

  @override
  @nonVirtual
  bool get isPersistent {
    return false;
  }

  @override
  @mustCallSuper
  Future<bool> put(T value) async {
    return add(Optional.presented(value));
  }

  @override
  @mustCallSuper
  Future<bool> flush() async {
    return add(Optional<T>.undefined());
  }
}
