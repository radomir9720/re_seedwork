import 'dart:async';
import 'package:meta/meta.dart';

class Throttler {
  @visibleForTesting
  final int milliseconds;

  @visibleForTesting
  Timer? timer;

  @visibleForTesting
  static const kDefaultDelay = 2000;

  Throttler({this.milliseconds = kDefaultDelay});

  void run(void Function() action) {
    if (timer?.isActive ?? false) return;

    timer?.cancel();
    action();
    timer = Timer(Duration(milliseconds: milliseconds), () {});
  }

  void dispose() {
    timer?.cancel();
  }
}
