import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

mixin ConsumerBlocMixin<State> on BlocBase<State> {
  @protected
  static final _subscriptions = Expando<List<StreamSubscription<Object?>>>();

  @protected
  @nonVirtual
  StreamSubscription<T> subscribe<T>(
    Stream<T> stream,
    void Function(T value) onData, {
    Function? onError,
    bool? cancelOnError,
    void Function()? onDone,
  }) {
    final subscription = stream.listen(
      onData,
      onDone: onDone,
      onError: onError,
      cancelOnError: cancelOnError,
    );

    _subscriptions[this] ??= [];
    _subscriptions[this]?.add(subscription);

    return subscription;
  }

  @override
  Future<void> close() async {
    final subscriptions = _subscriptions[this] ?? [];

    for (final subscription in subscriptions.reversed) {
      await subscription.cancel();
    }

    await super.close();
  }
}
