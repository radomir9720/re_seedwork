extension CheckNotNullExtension<T> on T? {
  T checkNotNull([String? name]) {
    return ArgumentError.checkNotNull<T>(this, name);
  }
}
