import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/flutter_fast_ui_platform_interface.dart';
import 'package:flutter_fast_ui/flutter_fast_ui_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterFastUiPlatform
    with MockPlatformInterfaceMixin
    implements FlutterFastUiPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterFastUiPlatform initialPlatform = FlutterFastUiPlatform.instance;

  test('$MethodChannelFlutterFastUi is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterFastUi>());
  });

  test('getPlatformVersion', () async {
    FastUI flutterFastUiPlugin = FastUI();
    MockFlutterFastUiPlatform fakePlatform = MockFlutterFastUiPlatform();
    FlutterFastUiPlatform.instance = fakePlatform;

    expect(await flutterFastUiPlugin.getPlatformVersion(), '42');
  });

  test("解析 json", () {
    final value = jsonDecode(
        jsonEncode({
          'type': 'container',
          'color': "0xFF000000",
          'child': {
            'type': "text",
            'color': "0xFFffffff",
            'text': 'Running on: '
          }
        }), reviver: (key, value) {
      if (value is Map && value.containsKey('type')) {
        if (value.containsKey('color')) {
          value['color'] = Color(int.parse(value['color']));
        }
      }
      return value;
    });
    print(value);
  });
  test("提取变量", () {
    // List<String> variableNames = [];
    // 正则表达式模式，匹配${变量名}
    // final pattern = RegExp(r'\$\{[^}]+}');
    final pattern = RegExp(r'\$\{([^}]*)\}');
    const input = r"asdfasdgtast 年少的发生的${  name } asdf ${age}  ${name}";
    const data = {
      "name": "名字",
      "age": 123,
    };
    final res = input.replaceAllMapped(pattern, (match) {
      if (match[0] != null) {
        final reg = RegExp(r"(?<=\$\{)(.*?)(?=\})");
        final item = reg.firstMatch(match[0]!);
        if (item?[0] != null) {
          final dataValue = data[item![0]!.trim()].toString();
          return dataValue;
          // result = result.replaceAll(item![0]!, dataValue ?? "");
        }
      }
      return "";
    });
    final matches = pattern.allMatches(input);

    var result = input;

    for (Match match in matches) {
      // 从匹配结果中获取变量名
      // print(match.group(1) ?? "---");
      print(match[0] ?? "---");
      if (match[0] != null) {
        final reg = RegExp(r"(?<=\$\{)(.*?)(?=\})");
        final item = reg.firstMatch(match[0]!);
        if (item?[0] != null) {
          final dataValue = data[item![0]!.trim()].toString();
          result = result.replaceAll(match![0]!, dataValue ?? "");
        }
      }
    }
    print(result);
    print(matches.length);
  });
  test("提取 函数名称和变量名", () {
    final input = "@{test(\$name,你好)}";
    final functionNameRegex = RegExp(r"[a-zA-Z]*(?=\()");
    final match = functionNameRegex.firstMatch(input);
    print("@@@@===> ${match?[0]}");

    final argsRegex = RegExp(r"\(\s*([^)]+?)\s*\)");
    final argsMatch = argsRegex.firstMatch(input);
    print("@@@=>>${argsMatch?[0]}  ${argsMatch?[1]}");

    final [name, age] = ["你好", 123];

    print("@@@ $name  , @@@ $age");

    // if (argsMatch?[1] != null) {
    //   final args =
    //       argsMatch![1]!.split(",");
    //   for (var element in args) {
    //     element.trim();
    //   }
    //   print("@@@@===> ${args}");
    // }
  });
}
