// ignore_for_file: must_call_super, invalid_use_of_protected_member

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

/// Base event class for all [EffectBlocMixin] side effect events.
abstract class EffectEvent {
  @literal
  const EffectEvent();
}

/// Notifies a [EffectBlocMixin] of a side effect.
@sealed
class _FireEffectEvent<T extends Object> implements EffectEvent {
  @protected
  final T value;

  @literal
  const _FireEffectEvent(this.value);
}

class _DefaultBlocObserver extends BlocObserver {}

mixin EffectBlocMixin<Event extends EffectEvent, State> on Bloc<Event, State> {
  @protected
  static final _subscriptions = Expando<List<StreamSubscription<Object?>>>();

  @protected
  static final _defaultBlocObserver = _DefaultBlocObserver();

  @override
  void onEvent(covariant EffectEvent event) {
    _defaultBlocObserver.onEvent(this, event);
  }

  @override
  void onTransition(covariant Transition<EffectEvent, State> transition) {
    _defaultBlocObserver.onTransition(this, transition);
  }

  @protected
  @nonVirtual
  void addEffect<T extends Object>(
    Stream<T> stream,
    State Function(T value) reducer,
  ) {
    _subscriptions[this] ??= [];
    _subscriptions[this]?.add(stream.listen(_reducer(reducer)));
  }

  @protected
  void Function(T value) _reducer<T extends Object>(
    State Function(T value) reducer,
  ) {
    return (value) {
      final event = _FireEffectEvent<T>(value);
      onEvent(event);

      try {
        final transition = Transition(
          currentState: state,
          event: event,
          nextState: reducer(value),
        );

        onTransition(transition);
        // ignore: invalid_use_of_visible_for_testing_member
        emit(transition.nextState);
      } on Object catch (error, stackTrace) {
        onError(error, stackTrace);
      }
    };
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
