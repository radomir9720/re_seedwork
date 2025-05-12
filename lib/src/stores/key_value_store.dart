import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:re_seedwork/src/stores/base_store.dart';

/// ReadOnlyKeyValueStore
abstract class ReadOnlyKeyValueStore<K, V>
    implements BaseStore<UnmodifiableMapView<K, V>> {
  /// The current store data.
  UnmodifiableMapView<K, V> get data;

  /// The value for the given [key], or `null` if [key] is not in the storage.
  V? operator [](K key);

  /// Whether this storage contains the given [key].
  bool containsKey(K key);
}

/// KeyValueStore
abstract class KeyValueStore<K, V> implements ReadOnlyKeyValueStore<K, V> {
  /// Flushs any stored data.
  Future<bool> flush();

  /// Deletes the value from the store.
  Future<bool> delete(K key);

  /// Updates the value associated with this key.
  Future<bool> put(K key, V value);

  /// Updates all the given key/value pairs.
  Future<bool> putAll(Iterable<MapEntry<K, V>> entries);
}

/// KeyValueStoreSink
abstract class KeyValueStoreSink<K, V> extends Stream<UnmodifiableMapView<K, V>>
    implements Sink<UnmodifiableMapView<K, V>>, KeyValueStore<K, V> {
  @protected
  late Map<K, V> _map;

  @protected
  @nonVirtual
  @visibleForTesting
  final StreamController<UnmodifiableMapView<K, V>> controller;

  KeyValueStoreSink([
    Map<K, V> map = const {},
  ]) : controller = StreamController.broadcast() {
    _map = {...map};
  }

  @override
  @nonVirtual
  V? operator [](K key) {
    return _map[key];
  }

  @override
  @nonVirtual
  UnmodifiableMapView<K, V> get data {
    return UnmodifiableMapView(_map);
  }

  @override
  @nonVirtual
  bool containsKey(K key) {
    return _map.containsKey(key);
  }

  @override
  @protected
  @nonVirtual
  bool add(Map<K, V> map) {
    if (controller.isClosed) {
      return false;
    }

    _map = map;
    controller.add(UnmodifiableMapView(_map));

    return true;
  }

  @override
  @nonVirtual
  bool get isBroadcast {
    return controller.stream.isBroadcast;
  }

  @override
  @nonVirtual
  StreamSubscription<UnmodifiableMapView<K, V>> listen(
    void Function(UnmodifiableMapView<K, V> value)? onData, {
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
  Stream<UnmodifiableMapView<K, V>> asBroadcastStream({
    void Function(StreamSubscription<UnmodifiableMapView<K, V>> subscription)?
        onListen,
    void Function(StreamSubscription<UnmodifiableMapView<K, V>> subscription)?
        onCancel,
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

// InMemoryKeyValueStore
class InMemoryKeyValueStore<K, V> extends KeyValueStoreSink<K, V> {
  InMemoryKeyValueStore([super.map]);

  @override
  @nonVirtual
  bool get isPersistent {
    return false;
  }

  @override
  @mustCallSuper
  Future<bool> put(K key, V value) async {
    if (controller.isClosed) {
      return false;
    }

    add({..._map, key: value});
    return true;
  }

  @override
  @mustCallSuper
  Future<bool> putAll(Iterable<MapEntry<K, V>> entries) async {
    if (controller.isClosed) {
      return false;
    }

    add({..._map}..addEntries(entries));
    return true;
  }

  @override
  @mustCallSuper
  Future<bool> flush() async {
    if (controller.isClosed) {
      return false;
    }

    add({});
    return true;
  }

  @override
  @mustCallSuper
  Future<bool> delete(K key) async {
    if (controller.isClosed) {
      return false;
    }

    if (!containsKey(key)) {
      return false;
    }

    add({..._map}..remove(key));
    return true;
  }
}
