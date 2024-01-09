import 'package:flutter/foundation.dart';

class RegexUtils {
  ///变量正则
  static const String variableRegex = r'\$\{([^}]*)\}';
  static const String variableNameRegex = r"(?<=\$\{)(.*?)(?=\})";

  ///函数正则
  static const String methodRegex = r'\@\{([^}]*)\}';
  static const String methodNameRegex = r"(?<=\@\{)(.*?)(?=\})";
  static const String functionNameRegex = r"[a-zA-Z]*(?=\()";
  static const String argsNameRegex = r"\(\s*([^)]+?)\s*\)";

  ///替换字符串中的变量
  ///[input] 待变量的字符串： "你好${hello} ，我是 ${name}"
  ///[data] 变量集合:  { "hello":"你好","name":"哈哈哈"}
  static String replaceStringVariable(String input, Map<String, dynamic> data) {
    return input.replaceAllMapped(RegExp(variableRegex), (match) {
      if (match[0] != null) {
        final item = getVariableNameByString(match[0]!);
        if (item != null) {
          final dataValue = data[item];
          return (dataValue is ValueListenable ? dataValue.value : dataValue)
              .toString();
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
  ///返回 [函数名，参数列表]
  static (String?, List<String>) getMethodNameByString(String input) {
    final nameRegex = RegExp(functionNameRegex);
    final nameMatch = nameRegex.firstMatch(input);

    //TODO 获取参数的正则待优化
    final argsRegex = RegExp(argsNameRegex);
    final argsMatch = argsRegex.firstMatch(input);
    var args = <String>[];
    if (argsMatch?[1] != null) {
      args = argsMatch![1]!.split(",");
      for (var element in args) {
        element.trim();
      }
    }
    return (nameMatch?[0]?.trim(), args);
  }
}
