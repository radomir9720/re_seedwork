import 'dart:async';

import 'package:meta/meta.dart';
import 'package:re_seedwork/src/collections/map_view.dart';
import 'package:re_seedwork/src/extensions/map_extensions.dart';
import 'package:re_seedwork/src/stores/value_store.dart';

/// {@template state.ReadOnlyKeyValueStore}
/// An interface for streamable key-value store.
/// {@endtemplate}
abstract class ReadOnlyKeyValueStore<K, V> implements StoreBase<MapView<K, V>> {
  /// The value for the given [key], or `null` if [key] is not in the storage.
  V? operator [](K key);

  /// Whether this storage contains the given [key].
  bool containsKey(K key);

  /// Creates a new stream that returns element changes.
  Stream<V?> watch({required K key});
}

/// {@template state.KeyValueStoreSink}
/// A base interface for key-value store.
/// {@endtemplate}
abstract class KeyValueStoreSink<K, V> implements ReadOnlyKeyValueStore<K, V> {
  /// Flushs any stored data.
  Future<void> flush();

  /// Deletes the value from the store.
  Future<void> delete(K key);

  /// Updates the value associated with this key.
  Future<void> put(K key, V value);

  /// Updates all the given key/value pairs.
  Future<void> putAll(Iterable<MapEntry<K, V>> entries);
}

/// {@template state.InMemoryKeyValueStore}
/// A simple in-memory implementation of the [KeyValueStoreSink].
/// {@endtemplate}
class InMemoryKeyValueStore<K, V extends Object>
    implements KeyValueStoreSink<K, V>, Sink<Map<K, V>> {
  @protected
  MapView<K, V> _state;

  @nonVirtual
  @visibleForTesting
  final StreamController<MapView<K, V>> controller;

  InMemoryKeyValueStore([
    final Map<K, V> map = const {},
  ])  : _state = MapView(map.whereNotNull()),
        controller = StreamController.broadcast();

  @override
  MapView<K, V> get state {
    return _state;
  }

  @override
  Stream<MapView<K, V>> get stream {
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
  V? operator [](K key) {
    return _state[key];
  }

  @override
  Stream<V?> watch({
    required final K key,
  }) {
    final controller = StreamController<V?>(sync: true);
    controller.onListen = () {
      controller.add(_state[key]);
      final subscription = stream.map((map) => map[key]).listen(controller.add);
      controller.onCancel = () {
        subscription.cancel();
        controller.close();
      };
    };
    return controller.stream.distinct(identical);
  }

  @override
  bool containsKey(K key) {
    return _state.containsKey(key);
  }

  @override
  Future<void> put(
    final K key,
    final V value,
  ) async {
    if (controller.isClosed) {
      return;
    }

    return add({..._state, key: value});
  }

  @override
  Future<void> putAll(
    final Iterable<MapEntry<K, V>> entries,
  ) async {
    if (controller.isClosed) {
      return;
    }

    add({..._state}..addEntries(entries));
  }

  @override
  Future<void> delete(K key) async {
    if (controller.isClosed) return;
    if (!containsKey(key)) return;

    add({..._state}..remove(key));
  }

  @override
  Future<void> flush() async {
    if (controller.isClosed) {
      return;
    }

    add({});
  }

  @override
  @protected
  @nonVirtual
  void add(Map<K, V> data) {
    if (controller.isClosed) {
      return;
    }

    _state = MapView({...data});
    controller.add(_state);
  }

  @override
  Future<void> close() {
    return controller.close();
  }
}
