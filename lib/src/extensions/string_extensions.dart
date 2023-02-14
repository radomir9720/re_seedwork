extension CapitalizeExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    if (length == 1) return toUpperCase();
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension SplitByIndexesExtension on String {
  List<String> splitByIndexes(List<int> indexes) {
    if (isEmpty) return [];
    var index = 0;
    final parts = <String>[];
    for (final i in indexes) {
      if (i == 0) continue;
      if (i == length) continue;
      parts.add(substring(index, i));
      index = i;
    }
    parts.add(substring(index, length));
    return parts;
  }
}

extension OnlyDigitsExtension on String {
  /// Returns only digits from current string
  String get onlyDigits {
    return replaceAll(RegExp(r'\D'), '');
  }
}
