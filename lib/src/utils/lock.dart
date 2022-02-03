import 'dart:async';

import 'package:meta/meta.dart';

class Lock<T> {
  @protected
  Future<void>? _lock;

  Future<T> acquire(Future<T> Function() zone) async {
    final lock = _lock;

    final completer = Completer<void>();
    _lock = completer.future;

    if (lock != null) await lock;

    try {
      return await zone();
    } finally {
      if (identical(_lock, completer.future)) {
        _lock = null;
      }
      completer.complete();
    }
  }
}
