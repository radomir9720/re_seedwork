import 'dart:async';

import 'package:flutter/foundation.dart';

class Throttler {
  @visibleForTesting
  final int milliseconds;

  @visibleForTesting
  Timer? timer;

  @visibleForTesting
  static const kDefaultDelay = 2000;

  Throttler({this.milliseconds = kDefaultDelay});

  void run(VoidCallback action) {
    if (timer?.isActive ?? false) return;

    timer?.cancel();
    action();
    timer = Timer(Duration(milliseconds: milliseconds), () {});
  }

  void dispose() {
    timer?.cancel();
  }
}
