import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/src/parser/decorates/base.dart';
import 'package:flutter_fast_ui/src/parser/view/base.dart';
import 'package:flutter_fast_ui/src/types.dart';

import '../flutter_fast_ui_platform_interface.dart';
import 'const/keys.dart';
import 'parser/fast_sys_parser.dart';
import 'parser/scheme/scheme.dart';

class FastUI {
  static final systemParser = FastSystemParser();

  Future<String?> getPlatformVersion() {
    return FlutterFastUiPlatform.instance.getPlatformVersion();
  }

  ///解析 配置
  static FastWidget? decodeConfig(Map<String, dynamic> config) {
    if (config.containsKey(FastKey.type)) {
      return _parseConfigJson(
        config[FastKey.type],
        config,
        systemParser.parser,
      );
    }
    return null;
  }

  ///单独解析装饰器
  static FastDecorate? decodeDecorateConfig(Map<String, dynamic> config) {
    if (config.containsKey(FastKey.type)) {
      return _parseConfigJson(
        config[FastKey.type],
        config,
        systemParser.parserDecorate,
      );
    }
    return null;
  }

  ///解析配置的单个组件的 json
  static T? _parseConfigJson<T>(String type, FastUIConfig config,
      Map<String, FastConfigParserBuilder<T>> parsers) {
    final allParser = parsers;
    Map<String, dynamic> parsedConfig = {};
    if (config is Map<String, dynamic> &&
        config.containsKey(FastKey.type) &&
        allParser.containsKey(config[FastKey.type])) {
      final parser = allParser[config[FastKey.type]]!;
      //转换属性
      config.forEach((key, value) {
        var result = value;
        //执行约束转换
        FastScheme? scheme = parser.scheme[key];
        if (scheme != null) {
          result = _parserBySchemeValue(type, key, result, scheme);
        }
        //转换组件
        if (result is FastUIConfig && result.containsKey(FastKey.type)) {
          result = _parseConfigJson<T>(result[FastKey.type], result, parsers);
        }
        parsedConfig[key] = result;
      });

      //处理装饰器
      if (parsedConfig.containsKey(FastKey.decorate)) {
        if (T case FastWidget) {
          parsedConfig[FastKey.decorate] = _transformDecorateJson(parsedConfig);
        }
      }
      //映射类型
      return parser.builder(parsedConfig);
    }
    return null;
  }

  ///转换属性类型
  static T? _parserBySchemeValue<T>(
    String type,
    String key,
    dynamic value,
    FastScheme<T> scheme,
  ) {
    if (scheme.defaultValue != null && value == null) {
      value = scheme.defaultValue;
    }
    final errMsg = "组件：$type , $key";
    assert(
      scheme.require == false || value != null,
      '$errMsg:为必填参数。',
    );
    //一些特殊类型转换
    if (scheme.valueType case Color) {
      assert(value is int, "$errMsg:值必须为 int 类型");
      value = Color(value);
    } else if (scheme.valueType case EdgeInsets) {
      if (value is double) {
        value = EdgeInsets.all(value.toDouble());
      } else if (value is Map<String, double>) {
        if (value.containsKey('vertical') || value.containsKey('horizontal')) {
          value = EdgeInsets.symmetric(
            vertical: value['vertical'] ?? 0,
            horizontal: value['horizontal'] ?? 0,
          );
        } else {
          value = EdgeInsets.only(
            left: value['left'] ?? 0,
            right: value['right'] ?? 0,
            top: value['top'] ?? 0,
            bottom: value['bottom'] ?? 0,
          );
        }
      } else {
        value = EdgeInsets.zero;
      }
    }
    return value;
  }

  /// 解析装饰器配置
  static List<FastDecorate> _transformDecorateJson(FastUIConfig config) {
    final decorates = config[FastKey.decorate];
    List<FastDecorate?> result = [];
    if (decorates != null && decorates is List && decorates.isNotEmpty) {
      result =
          decorates.map<FastDecorate?>((e) => decodeDecorateConfig(e)).toList();
    }
    return result.nonNulls.toList();
  }
}
