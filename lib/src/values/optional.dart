import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@sealed
@immutable
abstract class Optional<V extends Object> {
  bool get isPresent;

  factory Optional([V? value]) {
    if (value == null) {
      return Optional<V>.undefined();
    }
    return Optional<V>.presented(value);
  }

  R when<R>({
    required R Function() undefined,
    required R Function(V value) presented,
  });

  V? get toNullable;

  @literal
  const factory Optional.undefined() = _OptionalUndefined<V>;

  @literal
  const factory Optional.presented(V value) = _OptionalPresented<V>;
}

@immutable
class _OptionalUndefined<V extends Object> extends Equatable
    implements Optional<V> {
  @literal
  const _OptionalUndefined();

  @override
  bool get isPresent => false;

  @override
  R when<R>({
    required R Function() undefined,
    required R Function(V value) presented,
  }) {
    return undefined();
  }

  @override
  V? get toNullable => null;

  @override
  List<Object?> get props => [];
}

@immutable
class _OptionalPresented<V extends Object> extends Equatable
    implements Optional<V> {
  @protected
  final V value;

  @literal
  const _OptionalPresented(this.value);

  @override
  bool get isPresent => true;

  @override
  R when<R>({
    required R Function() undefined,
    required R Function(V value) presented,
  }) {
    return presented(value);
  }

  @override
  V? get toNullable => value;

  @override
  List<Object?> get props => [isPresent, value];
}
