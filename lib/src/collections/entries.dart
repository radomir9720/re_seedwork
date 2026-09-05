import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:re_seedwork/src/extensions/map_extensions.dart';

/// A string-keyed view of object properties.
typedef RawEntries = Map<String, Object?>;

/// A null safety string-keyed view of object properties.
@immutable
class Entries extends UnmodifiableMapView<String, Object> {
  /// Creates an [Entries] with the given raw entries.
  Entries(
    final RawEntries entries,
  ) : super(entries.whereNotNull());

  /// Creates an empty [Entries].
  Entries.empty() : super({});

  /// Creates an [Entries] with the given non-`null` entries.
  Entries.pure(
    final Map<String, Object> entries,
  ) : super({...entries});

  /// Creates a new [Entries] that contains records of the original collection
  /// and passed [entries].
  ///
  /// If a key of passed entry is already in this collection, its value is
  /// overwritten.
  @nonVirtual
  Entries merge([
    final RawEntries entries = const {},
  ]) {
    return Entries({...this, ...entries});
  }
}
