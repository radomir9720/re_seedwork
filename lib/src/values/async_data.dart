import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@sealed
@immutable
abstract class AsyncData<P, E extends Object> extends Equatable {
  @nonVirtual
  final P payload;

  @literal
  const AsyncData._(this.payload);

  @nonVirtual
  P get value => payload;

  @nonVirtual
  bool get isExecuted => isSuccess || isFailure;

  @nonVirtual
  bool get isInitial => this is _InitialState<P, E>;

  @nonVirtual
  bool get isLoading => this is _LoadingState<P, E>;

  @nonVirtual
  bool get isSuccess => this is _SuccessState<P, E>;

  @nonVirtual
  bool get isFailure => this is _FailureState<P, E>;

  @nonVirtual
  AsyncData<P, E> inInitial() {
    return _InitialState<P, E>(payload);
  }

  @nonVirtual
  AsyncData<P, E> inLoading() {
    return _LoadingState<P, E>(payload);
  }

  @nonVirtual
  AsyncData<P, E> inSuccess() {
    return _SuccessState<P, E>(payload);
  }

  @nonVirtual
  AsyncData<P, E> inFailure([E? error]) {
    return _FailureState<P, E>(payload, error);
  }

  R when<R>({
    required R Function(P payload) initial,
    required R Function(P payload) loading,
    required R Function(P payload) success,
    required R Function(P payload, E? error) failure,
  });

  R maybeWhen<R>({
    required R Function(P payload) orElse,
    R Function(P payload)? initial,
    R Function(P payload)? loading,
    R Function(P payload)? success,
    R Function(P payload, E? error)? failure,
  });

  @literal
  const factory AsyncData.initial(P payload) = _InitialState<P, E>;

  @literal
  const factory AsyncData.loading(P payload) = _LoadingState<P, E>;

  @literal
  const factory AsyncData.success(P payload) = _SuccessState<P, E>;

  @literal
  const factory AsyncData.failure(P payload, [E? error]) = _FailureState<P, E>;

  @override
  @internal
  List<Object?> get props => [payload];
}

@immutable
class _InitialState<P, E extends Object> extends AsyncData<P, E> {
  @literal
  const _InitialState(P payload) : super._(payload);

  @override
  @nonVirtual
  R when<R>({
    required R Function(P payload) initial,
    required R Function(P payload) loading,
    required R Function(P payload) success,
    required R Function(P payload, E? error) failure,
  }) {
    return initial(payload);
  }

  @override
  @nonVirtual
  R maybeWhen<R>({
    required R Function(P payload) orElse,
    R Function(P payload)? initial,
    R Function(P payload)? loading,
    R Function(P payload)? success,
    R Function(P payload, E? error)? failure,
  }) {
    if (initial != null) {
      return initial(payload);
    }
    return orElse(payload);
  }
}

@immutable
class _LoadingState<P, E extends Object> extends AsyncData<P, E> {
  @literal
  const _LoadingState(P payload) : super._(payload);

  @override
  @nonVirtual
  R when<R>({
    required R Function(P payload) initial,
    required R Function(P payload) loading,
    required R Function(P payload) success,
    required R Function(P payload, E error) failure,
  }) {
    return loading(payload);
  }

  @override
  @nonVirtual
  R maybeWhen<R>({
    required R Function(P payload) orElse,
    R Function(P payload)? initial,
    R Function(P payload)? loading,
    R Function(P payload)? success,
    R Function(P payload, E error)? failure,
  }) {
    if (loading != null) {
      return loading(payload);
    }
    return orElse(payload);
  }
}

@immutable
class _SuccessState<P, E extends Object> extends AsyncData<P, E> {
  @literal
  const _SuccessState(P payload) : super._(payload);

  @override
  @nonVirtual
  R when<R>({
    required R Function(P payload) initial,
    required R Function(P payload) loading,
    required R Function(P payload) success,
    required R Function(P payload, E? error) failure,
  }) {
    return success(payload);
  }

  @override
  @nonVirtual
  R maybeWhen<R>({
    required R Function(P payload) orElse,
    R Function(P payload)? initial,
    R Function(P payload)? loading,
    R Function(P payload)? success,
    R Function(P payload, E? error)? failure,
  }) {
    if (success != null) {
      return success(payload);
    }
    return orElse(payload);
  }
}

@immutable
class _FailureState<P, E extends Object> extends AsyncData<P, E> {
  @nonVirtual
  final E? error;

  @literal
  const _FailureState(P payload, [this.error]) : super._(payload);

  @override
  @nonVirtual
  R when<R>({
    required R Function(P payload) initial,
    required R Function(P payload) loading,
    required R Function(P payload) success,
    required R Function(P payload, E? error) failure,
  }) {
    return failure(payload, error);
  }

  @override
  @nonVirtual
  R maybeWhen<R>({
    required R Function(P payload) orElse,
    R Function(P payload)? initial,
    R Function(P payload)? loading,
    R Function(P payload)? success,
    R Function(P payload, E? error)? failure,
  }) {
    if (failure != null) {
      return failure(payload, error);
    }
    return orElse(payload);
  }

  @override
  List<Object?> get props => [...super.props, error];
}
