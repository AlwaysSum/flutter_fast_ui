extension ListExt<T> on List<T> {
  T? safeFirstWhere(bool Function(T? element) test) {
    return cast<T?>().firstWhere(test, orElse: () => null);
  }
}
