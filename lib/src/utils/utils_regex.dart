class RegexUtils {
  ///变量正则
  static const String variableRegex = r'\$\{([^}]*)\}';
  static const String variableNameRegex = r"(?<=\$\{)(.*?)(?=\})";

  ///函数正则
  static const String methodRegex = r'\@\{([^}]*)\}';
  static const String methodNameRegex = r"(?<=\@\{)(.*?)(?=\})";

  ///替换字符串中的变量
  ///[input] 待变量的字符串： "你好${hello} ，我是 ${name}"
  ///[data] 变量集合:  { "hello":"你好","name":"哈哈哈"}
  static String replaceStringVariable(String input, Map<String, dynamic> data) {
    return input.replaceAllMapped(RegExp(variableRegex), (match) {
      if (match[0] != null) {
        final item = getVariableNameByString(match[0]!);
        if (item != null) {
          final dataValue = data[item].toString();
          return dataValue;
        }
      }
      return "";
    });
  }

  ///获取变量名
  static String? getVariableNameByString(String input) {
    final item = RegExp(variableNameRegex).firstMatch(input);
    return item?[0]?.trim();
  }

  ///获取变量名
  static String? getMethodNameByString(String input) {
    final item = RegExp(methodNameRegex).firstMatch(input);
    return item?[0]?.trim();
  }
}
