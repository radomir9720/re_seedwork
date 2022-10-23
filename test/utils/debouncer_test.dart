import 'package:flutter_test/flutter_test.dart';
import 'package:re_seedwork/re_seedwork.dart';

void main() {
  group('Debouncer', () {
    const delay = 500;
    late Debouncer debouncer;

    Future<void> delayFuture() =>
        Future<void>.delayed(const Duration(milliseconds: delay));

    setUp(() {
      debouncer = Debouncer(milliseconds: delay);
    });

    test('Does not run action until timer is active', () async {
      var actionRun = false;
      debouncer.run(() => actionRun = true);
      expect(actionRun, isFalse);
      await delayFuture();
      expect(actionRun, isTrue);
    });

    test('Runs only the last action', () async {
      var n = 0;
      for (var i = 0; i <= 10; i++) {
        debouncer.run(() => n++);
      }
      expect(n, equals(0));
      await delayFuture();
      expect(n, 1);
    });

    group('completerFuture getter', () {
      test('initially is completed by default', () async {
        final stopwatch = Stopwatch()..start();
        await debouncer.completerFuture;
        stopwatch.stop();
        final elapsed = stopwatch.elapsedMilliseconds;
        // Tolerance 5 milliseconds
        expect(elapsed, lessThanOrEqualTo(5));
      });

      test('completes when action was executed', () async {
        debouncer.run(() {});
        final stopwatch = Stopwatch()..start();
        await debouncer.completerFuture;
        stopwatch.stop();
        final elapsed = stopwatch.elapsedMilliseconds;
        // Tolerance 10 milliseconds
        expect((elapsed - delay).abs(), lessThanOrEqualTo(10));
      });

      test('resets completer when old one was completed', () async {
        debouncer.run(() {});
        await debouncer.completerFuture;
        final stopwatch = Stopwatch()..start();
        debouncer.run(() {});
        await debouncer.completerFuture;
        stopwatch.stop();
        final elapsed = stopwatch.elapsedMilliseconds;
        // Tolerance 10 milliseconds
        expect((elapsed - delay).abs(), lessThanOrEqualTo(10));
      });
    });

    group('isCompleted getter', () {
      test('initially is true', () {
        expect(debouncer.isCompleted, isTrue);
      });

      test('becomes true when action is executed', () async {
        debouncer.run(() {});
        await delayFuture();
        expect(debouncer.isCompleted, isTrue);
      });
    });

    group('dispose', () {
      test('completes the completer', () async {
        final stopwatch = Stopwatch()..start();
        debouncer.run(() {});
        debouncer.dispose();
        await debouncer.completerFuture;
        stopwatch.stop();
        final ellapsed = stopwatch.elapsedMilliseconds;
        // Tolerance 10 milliseconds
        expect(ellapsed, lessThanOrEqualTo(10));
      });

      test('isCompleted getter returns true after dispose was called',
          () async {
        debouncer.run(() {});
        debouncer.dispose();
        expect(debouncer.isCompleted, isTrue);
      });
    });

    tearDown(() {
      debouncer.dispose();
    });
  });
}
