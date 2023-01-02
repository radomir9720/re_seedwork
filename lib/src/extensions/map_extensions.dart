import 'package:re_seedwork/re_seedwork.dart';

extension MapParserExtension on Map<String, dynamic> {
  T parse<T>(String key) {
    return (this[key] as T?).checkNotNull(key);
  }

  T? tryParse<T>(String key) {
    return this[key] as T?;
  }

  List<T> tryParseList<T>(String key) {
    return (this[key] as List?)?.cast<T>() ?? [];
  }

  T? tryParseAndMap<T, Y>(String key, T Function(Y) onPresent) {
    final value = this[key] as Y?;

    return value == null ? null : onPresent(value);
  }

  T parseAndMap<T, Y>(String key, T Function(Y) onPresent) {
    final value = (this[key] as Y?).checkNotNull(key);

    return onPresent(value);
  }

  List<T> tryParseAndMapList<T, Y>(String key, T Function(Y value) mapper) {
    final value = (this[key] as List?)?.cast<Y>();

    return value?.map(mapper).toList() ?? [];
  }
}
