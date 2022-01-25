import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@sealed
@immutable
abstract class Result<E, V> extends Equatable {
  @nonVirtual
  final bool isError;

  @nonVirtual
  final bool isValue;

  @literal
  const Result._({required this.isError}) : isValue = !isError;

  R when<R>({
    required R Function(E error) error,
    required R Function(V value) value,
  });

  @literal
  const factory Result.error(E error) = _ResultError<E, V>;

  @literal
  const factory Result.value(V value) = _ResultValue<E, V>;

  @override
  @internal
  @protected
  List<Object?> get props;
}

@immutable
class _ResultError<E, V> extends Result<E, V> {
  @protected
  final E error;

  @literal
  const _ResultError(this.error) : super._(isError: true);

  @override
  R when<R>({
    required R Function(E error) error,
    required R Function(V value) value,
  }) {
    return error(this.error);
  }

  @override
  List<Object?> get props => [error];
}

@immutable
class _ResultValue<E, V> extends Result<E, V> {
  @protected
  final V value;

  @literal
  const _ResultValue(this.value) : super._(isError: false);

  @override
  R when<R>({
    required R Function(E error) error,
    required R Function(V value) value,
  }) {
    return value(this.value);
  }

  @override
  List<Object?> get props => [value];
}
