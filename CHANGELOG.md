## 2.0.0

* **BREAKING**: Reworked the stores to implement `StateStreamableSource<T>` from `bloc`.

  Stores now expose the current value via `state` and the stream of changes via `stream`.

  `BaseStore<T>` was removed and replaced with `StoreBase<T>`.

  Before:
  ```dart
  final store = InMemoryValueStore<int>(0);
  store.data;            // current value
  store.listen(print);   // store itself is a Stream
  ```
  Now:
  ```dart
  final store = InMemoryValueStore<int>(0);
  store.state;           // current value
  store.stream.listen(print); // store is a StateStreamableSource
  ```

* **BREAKING**: `put()`, `putAll()`, `delete()` and `flush()` now return `Future<void>` instead of `Future<bool>`.

* **BREAKING**: `ReadOnlyValueStore.data` and `ReadOnlyKeyValueStore.data` getters were renamed to `state`.

* **BREAKING**: Key-value stores no longer have a single `data` record.
  Added `watch({required K key})` — a per-key `Stream<V?>` that emits the current value first and then updates.

  ```dart
  final store = InMemoryKeyValueStore<String, int>({'coins': 5});
  store.watch(key: 'coins').listen(print); // 5, then every change
  ```

* **BREAKING**: `InMemoryKeyValueStore<K, V extends Object>` now requires a non-nullable value type `V`.

* **BREAKING**: Removed `OptionalValueStore` / `InMemoryOptionalValueStore`.
  Use `InMemoryValueStore` with `Optional<T>` instead.

* **BREAKING**: Removed the `rxdart` dependency.

* **FEATURE**: Added `MapView`, `ListView` and `SetView` — unmodifiable view aliases
  for `Map`, `List` and `Set`.

* **FEATURE**: Added `Entries` — an immutable, null-safety string-keyed `Map<String, Object?>` view
  with a `merge()` helper.

* **FEATURE**: Added `MapWhereNotNullExtension` — filters `null` values from a map.

## 1.0.0
* **BRAKING CHORE**: Added `Event` positional parameter to `action()` callback in `BlocEventHandlerMixin.handleEvent()`
  
  Before:
  ```dart
  handleEvent<Event, ActionResultType>(
      // ... other parameters
      action: () async {
        // ...
      },
    );
  ```
  Now:
  ```dart
  handleEvent<Event, ActionResultType>(
      // ... other parameters
      action: (event) async {
        // ...
      },
    );
  ```
