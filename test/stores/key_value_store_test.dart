import 'package:flutter_test/flutter_test.dart';
import 'package:re_seedwork/re_seedwork.dart';

void main() {
  group('InMemoryKeyValueStore.watch', () {
    test('emits the initial value first', () async {
      final store = InMemoryKeyValueStore<String, int>({'key': 5});
      final values = <int?>[];

      final sub = store.watch(key: 'key').listen(values.add);
      await Future<void>.delayed(Duration.zero);

      expect(values, [5]);
      await sub.cancel();
      await store.close();
    });

    test('emits null as the initial value for missing key', () async {
      final store = InMemoryKeyValueStore<String, int>(const {});
      final values = <int?>[];

      final sub = store.watch(key: 'key').listen(values.add);
      await Future<void>.delayed(Duration.zero);

      expect(values, [null]);
      await sub.cancel();
      await store.close();
    });

    test('emits subsequent changes after the initial value', () async {
      final store = InMemoryKeyValueStore<String, int>({'key': 1});
      final values = <int?>[];

      final sub = store.watch(key: 'key').listen(values.add);
      store.put('key', 2);
      store.put('key', 3);

      await Future<void>.delayed(Duration.zero);
      expect(values, [1, 2, 3]);
      await sub.cancel();
      await store.close();
    });

    test('does not emit duplicate consecutive values', () async {
      final store = InMemoryKeyValueStore<String, int>({'key': 1});
      final values = <int?>[];

      final sub = store.watch(key: 'key').listen(values.add);
      store.put('key', 1);
      store.put('key', 2);
      store.put('key', 2);

      await Future<void>.delayed(Duration.zero);
      expect(values, [1, 2]);
      await sub.cancel();
      await store.close();
    });

    test('emits null when the value is deleted', () async {
      final store = InMemoryKeyValueStore<String, int>({'key': 1});
      final values = <int?>[];

      final sub = store.watch(key: 'key').listen(values.add);
      store.delete('key');

      await Future<void>.delayed(Duration.zero);
      expect(values, [1, null]);
      await sub.cancel();
      await store.close();
    });

    test('does not emit after the store is closed', () async {
      final store = InMemoryKeyValueStore<String, int>({'key': 1});
      final values = <int?>[];

      final sub = store.watch(key: 'key').listen(values.add);
      await store.close();
      store.put('key', 2);

      expect(values, [1]);
      await sub.cancel();
      await store.close();
    });

    test('watches distinct keys independently', () async {
      final store = InMemoryKeyValueStore<String, int>({'a': 1, 'b': 10});
      final valuesA = <int?>[];
      final valuesB = <int?>[];

      final subA = store.watch(key: 'a').listen(valuesA.add);
      final subB = store.watch(key: 'b').listen(valuesB.add);
      store.put('a', 2);

      await Future<void>.delayed(Duration.zero);
      expect(valuesA, [1, 2]);
      expect(valuesB, [10]);
      await subA.cancel();
      await subB.cancel();
      await store.close();
    });
  });
}
