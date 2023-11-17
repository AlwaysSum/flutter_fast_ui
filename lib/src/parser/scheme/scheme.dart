class FastScheme<T> {
  ///默认值
  final T? defaultValue;

  ///是否必填
  final bool? require;

  FastScheme({this.defaultValue, this.require});

  Type get valueType {
    return T;
  }
}
