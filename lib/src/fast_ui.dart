import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/src/parser/decorates/base.dart';
import 'package:flutter_fast_ui/src/parser/view/base.dart';
import 'package:flutter_fast_ui/src/parser/view/fast_value_builder.dart';
import 'package:flutter_fast_ui/src/types.dart';
import 'package:flutter_fast_ui/src/utils/utils_regex.dart';
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
  static FastWidget? decodeConfig(
    Map<String, dynamic> config, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? methods,
  }) {
    if (config.containsKey(FastKey.type)) {
      final ui = _parseConfigJson(
        config[FastKey.type],
        config,
        systemParser.parser,
        data: data,
        methods: methods,
      );

      return ui;
    }
    return null;
  }

  ///单独解析装饰器
  static FastDecorate? decodeDecorateConfig(
    Map<String, dynamic> config, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? methods,
  }) {
    if (config.containsKey(FastKey.type)) {
      return _parseConfigJson(
        config[FastKey.type],
        config,
        systemParser.parserDecorate,
        data: data,
        methods: methods,
      );
    }
    return null;
  }

  ///解析配置的单个组件的 json
  static T? _parseConfigJson<T>(
    String type,
    FastUIConfig config,
    Map<String, FastConfigParserBuilder<T>> parsers, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? methods,
    bool skipNotifier = false,
  }) {
    final allParser = parsers;
    Map<String, dynamic> parsedConfig = {};
    final notifierValues = <String, ValueListenable>{};

    if (config is Map<String, dynamic> &&
        config.containsKey(FastKey.type) &&
        allParser.containsKey(config[FastKey.type])) {
      final parser = allParser[config[FastKey.type]]!;

      //转换属性
      config.forEach((key, value) {
        var result = value;
        //执行约束转换
        FastScheme? scheme = parser.scheme[key];
        // 解析变量和函数调用
        final (parsedResult, notifiers) = _parseDynamicMethodsAndVariable(
          value,
          scheme,
          data,
          methods,
        );
        result = parsedResult;
        notifierValues.addAll(notifiers);

        if (scheme != null) {
          result = _parserBySchemeValue(
            type,
            key,
            result,
            scheme,
            data: data,
            methods: methods,
          );
        }
        //转换组件
        if (result is FastUIConfig && result.containsKey(FastKey.type)) {
          result = _parseConfigJson<T>(
            result[FastKey.type],
            result,
            parsers,
            data: data,
            methods: methods,
          );
        }

        parsedConfig[key] = result;
      });

      if (T case FastWidget) {
        //处理装饰器
        if (parsedConfig.containsKey(FastKey.decorate)) {
          parsedConfig[FastKey.decorate] = _transformDecorateJson(
            parsedConfig,
            data: data,
            methods: methods,
          );
        }

        //TODO ------
        if (notifierValues.isNotEmpty && !skipNotifier) {
          return FastValueBuilder(
            values: notifierValues.values.toList(),
            builder: (context) {
              print("@@~~~ $data");
              return FastWidget.buildWidget(
                context,
                _parseConfigJson<T>(
                  type,
                  config,
                  parsers,
                  data: data,
                  methods: methods,
                  skipNotifier: true,
                ) as FastWidget,
              );
            },
          ) as T?;
        }
      }

      //映射类型
      return parser.builder(parsedConfig);
    }
    return null;
  }

  ///解析一些动态变量和函数
  static (T?, Map<String, ValueListenable>) _parseDynamicMethodsAndVariable<T>(
    dynamic value,
    FastScheme<T>? scheme,
    Map<String, dynamic>? data,
    Map<String, dynamic>? methods,
  ) {
    ///所有可监听的的动态变量
    final allUseValues = <String, ValueListenable>{};

    ///解析动态值、和函数方法
    if (value is String) {
      if (scheme?.valueType case String) {
        //替换字符串中的变量和函数
        final newInput =
            value.replaceAllMapped(RegExp(RegexUtils.variableRegex), (match) {
          if (match[0] != null) {
            final item = RegexUtils.getVariableNameByString(match[0]!);
            if (item != null) {
              final dataValue = data?[item];
              if (dataValue is ValueListenable) {
                allUseValues[item] = dataValue;
                return dataValue.value.toString();
              } else {
                return dataValue.toString();
              }
            }
          }
          return "";
        });
        return (newInput as T?, allUseValues);
      } else {
        //获取函数或变量
        if (value.startsWith("@{") && value.endsWith("}")) {
          //获取需要的函数
          final (name, args) = RegexUtils.getMethodNameByString(value);
          final method = methods?[name];

          if (method != null && method is Function) {
            //解析参数中的变量
            final argsList = args.map((e) {
              if (e.startsWith("\${") && e.endsWith("}")) {
                //需要获取变量
                final subName = RegexUtils.getVariableNameByString(e);
                final subValue = data?[subName];
                if (subValue != null) {
                  allUseValues[subName!] = subValue;
                }
                return subValue;
              }
              return e;
            }).toList();

            return (method(argsList), allUseValues);
          }
        } else if (value.startsWith("\${") && value.endsWith("}")) {
          //需要获取变量
          final name = RegexUtils.getVariableNameByString(value);
          final dataValue = data?[name];
          if (dataValue != null) {
            allUseValues[name!] = dataValue;
            if (dataValue is ValueListenable) {
              value = dataValue.value;
            } else {
              value = dataValue;
            }
          }
          return (value, allUseValues);
        }
      }
    }
    return (value, allUseValues);
  }

  ///转换属性类型
  static T? _parserBySchemeValue<T>(
    String type,
    String key,
    dynamic value,
    FastScheme<T> scheme, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? methods,
  }) {
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
      if (value is num) {
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
  static List<FastDecorate> _transformDecorateJson(
    FastUIConfig config, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? methods,
  }) {
    final decorates = config[FastKey.decorate];
    List<FastDecorate?> result = [];
    if (decorates != null && decorates is List && decorates.isNotEmpty) {
      result = decorates
          .map<FastDecorate?>((e) => decodeDecorateConfig(
                e,
                data: data,
                methods: methods,
              ))
          .toList();
    }
    return result.nonNulls.toList();
  }
}
