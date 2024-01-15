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

abstract class FastSchemeParser<T> {
  Type get valueType {
    return T;
  }

  ///从 JSON 处解析值
  T parserJson(dynamic value);
}

///直接构建函数
class FastSchemeParserBuilder<T> extends FastSchemeParser<T> {
  ///从 JSON 处解析值
  final T Function(dynamic value) parser;

  FastSchemeParserBuilder(this.parser);

  @override
  T parserJson(value) {
    return this.parser(value);
  }
}
