extension ListExt<T> on List<T> {
  T? safeFirstWhere(bool Function(T? element) test) {
    return cast<T?>().firstWhere(test, orElse: () => null);
  }

  ///加入新项
  List<T> joinItem(T Function(int index) getItem) {
    List<T> newList = [];
    asMap().keys.forEach((element) {
      newList.add(this[element]);
      if (element < length - 1) {
        newList.add(getItem(element));
      }
    });
    return newList;
  }
}
