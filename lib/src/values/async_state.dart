import 'package:meta/meta.dart';

@sealed
@immutable
abstract class AsyncState<E extends Object> {
  @literal
  const AsyncState._();

  @nonVirtual
  bool get isExecuted => isSuccess || isFailure;

  @nonVirtual
  bool get isInitial => this is _InitialState<E>;

  @nonVirtual
  bool get isLoading => this is _LoadingState<E>;

  @nonVirtual
  bool get isSuccess => this is _SuccessState<E>;

  @nonVirtual
  bool get isFailure => this is _FailureState<E>;

  @nonVirtual
  AsyncState<E> inInitial() {
    return _InitialState<E>();
  }

  @nonVirtual
  AsyncState<E> inLoading() {
    return _LoadingState<E>();
  }

  @nonVirtual
  AsyncState<E> inSuccess() {
    return _SuccessState<E>();
  }

  @nonVirtual
  AsyncState<E> inFailure([E? error]) {
    return _FailureState<E>(error);
  }

  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function() success,
    required R Function(E? error) failure,
  });

  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? initial,
    R Function()? loading,
    R Function()? success,
    R Function(E? error)? failure,
  });

  @literal
  const factory AsyncState.initial() = _InitialState<E>;

  @literal
  const factory AsyncState.loading() = _LoadingState<E>;

  @literal
  const factory AsyncState.success() = _SuccessState<E>;

  @literal
  const factory AsyncState.failure([E? error]) = _FailureState<E>;
}

@immutable
class _InitialState<E extends Object> extends AsyncState<E> {
  @literal
  const _InitialState() : super._();

  @override
  @nonVirtual
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function() success,
    required R Function(E? error) failure,
  }) {
    return initial();
  }

  @override
  @nonVirtual
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? initial,
    R Function()? loading,
    R Function()? success,
    R Function(E? error)? failure,
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is _InitialState<E>;
  }
}

@immutable
class _LoadingState<E extends Object> extends AsyncState<E> {
  @literal
  const _LoadingState() : super._();

  @override
  @nonVirtual
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function() success,
    required R Function(E error) failure,
  }) {
    return loading();
  }

  @override
  @nonVirtual
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? initial,
    R Function()? loading,
    R Function()? success,
    R Function(E error)? failure,
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is _LoadingState<E>;
  }
}

@immutable
class _SuccessState<E extends Object> extends AsyncState<E> {
  @literal
  const _SuccessState() : super._();

  @override
  @nonVirtual
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function() success,
    required R Function(E? error) failure,
  }) {
    return success();
  }

  @override
  @nonVirtual
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? initial,
    R Function()? loading,
    R Function()? success,
    R Function(E? error)? failure,
  }) {
    if (success != null) {
      return success();
    }
    return orElse();
  }

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is _SuccessState<E>;
  }
}

@immutable
class _FailureState<E extends Object> extends AsyncState<E> {
  @nonVirtual
  final E? error;

  @literal
  const _FailureState([this.error]) : super._();

  @override
  @nonVirtual
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function() success,
    required R Function(E? error) failure,
  }) {
    return failure(error);
  }

  @override
  @nonVirtual
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? initial,
    R Function()? loading,
    R Function()? success,
    R Function(E? error)? failure,
  }) {
    if (failure != null) {
      return failure(error);
    }
    return orElse();
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, error);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _FailureState<E> && other.error == error;
  }
}
