# re_seedwork

Reusable base classes and interfaces for Dart and Flutter applications.

`re_seedwork` collects the building blocks that repeat across projects: stores
with streamable state, sealed data types for async/result/optional values,
Bloc helpers, small utilities, and a set of map/string/iterable extensions.

## Features

- **Stores** — streamable in-memory state containers implementing [`StateStreamableSource`](https://pub.dev/documentation/bloc/latest/bloc/StateStreamableSource-class.html):
  - `InMemoryValueStore<T>` — single value store with `put`, `state`, `stream`, and `watch`-friendly `Stream` API.
  - `InMemoryKeyValueStore<K, V>` — key-value store with `put`, `putAll`, `delete`, `flush`, and per-key `watch({required key})` that always emits the current value first.
  - Both expose `state`, `stream`, `isPersistent`, `isClosed`, and `close()`.
- **Value types** — sealed, `Equatable`-based discriminated unions:
  - `Result<E, V>` — `.error(e)` / `.value(v)` with exhaustive `when`.
  - `Optional<V>` — `undefined()` / `presented(value)` with `when` and `toNullable`.
  - `AsyncData<P, E>` — `initial` / `loading` / `success` / `failure` carrying a `payload`, with `when`, `maybeWhen`, `copyWith`.
  - `AsyncState<E>` — the same phase model without a payload.
- **Bloc helpers** — mixins on top of `bloc`:
  - `EffectBlocMixin` — subscribe to side-effect streams and fold their values into state via `addEffect(stream, reducer)`.
  - `BlocEventHandlerMixin` — declarative loading/failure/success handling with `handleEvent` and `handle`.
  - `ConsumerBlocMixin`, `BlocLoggerMixin`.
- **Collections** — immutable view aliases (`MapView`, `ListView`, `SetView`) and entry helpers.
- **Utilities**:
  - `Debouncer` — collapse bursts of calls into one, with a `completerFuture` to await completion.
  - `Throttler` — run at most once per window.
  - `Lock<T>` — serialize concurrent async work.
- **Extensions** — for `Map`, `String`, `Object`, `Iterable`, and `DateTime`.

## Getting started

This package targets Dart SDK `>=2.17.0`. Add a dependency:

```yaml
dependencies:
  re_seedwork: ^2.0.0
```

## Usage

### Stores

Listen to a store's stream, or watch one key:

```dart
final store = InMemoryKeyValueStore<String, int>({'coins': 5});

// Emits the current value first, then every change.
store.watch(key: 'coins').listen(print); // 5, then updates

await store.put('coins', 6); // stream emits 6
final coins = store['coins']; // 6
await store.close();
```

A single-value store:

```dart
final store = InMemoryValueStore<int>(0);

final sub = store.stream.listen(print); // 0
await store.put(1);                     // 1
await store.close();
```

### Values

Use sealed value types instead of nullable business state:

```dart
final result = Result<String, int>.value(42);
final message = result.when(
  error: (e) => 'Failed: $e',
  value: (v) => 'Got $v',
); // 'Got 42'
```

Async phase model for UI states:

```dart
AsyncData<List<Item>, ApiError> data = AsyncData.initial(const []);

// in a bloc / repository:
data = data.inLoading();
data = data.inSuccess();

final snapshot = data.when(
  initial: (items) => items,
  loading: (items) => items,
  success: (items) => items,
  failure: (items, error) => items,
);
```

`Optional` for nullable values that must never be confused with "no value":

```dart
final maybeName = Optional<String>(); // undefined
maybeName.when(
  undefined: () => 'Anonymous',
  presented: (name) => name,
);
```

### Bloc helpers

Fold a side-effect stream into state:

```dart
class CounterBloc extends Bloc<CounterEvent, int>
    with EffectBlocMixin<EffectEvent, int> {
  CounterBloc() : super(0) {
    addEffect<int>(_counterStream, (increment) => state + increment);
  }
}
```

Handle an event with uniform loading/failure transitions:

```dart
on<LoadItems>((event, emit) {
  return handleEvent(
    inLoading: () => const ItemsState.loading(),
    inFailure: () => const ItemsState.failure(),
    action: (event) => repository.fetchItems(),
    onActionResult: (items) => ItemsState.success(items),
  );
});
```

### Utilities

```dart
final debouncer = Debouncer(milliseconds: 300);
searchField.onChanged = (query) => debouncer.run(() => search(query));

final lock = Lock<void>();
await lock.acquire(() => refreshToken());

final throttler = Throttler(milliseconds: 500);
button.onTap = () => throttler.run(submit);
```

## Additional information

Refer to the inline documentation in [`lib/`](lib/) for details on every class
and mixin. Tests live under [`test/`](test/) and can be run with `flutter test`.
This package is published through [pub.dev](https://pub.dev/packages/re_seedwork).