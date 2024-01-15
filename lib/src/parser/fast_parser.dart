import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/src/extensions/ext_list.dart';
import 'package:flutter_fast_ui/src/utils/utils_value.dart';

import '../../flutter_fast_ui.dart';
import '../utils/utils_regex.dart';

/// 解析器
class FastParser {
  /// 数据集合
  final Map<String, dynamic> data;

  /// 函数集合
  final Map<String, FastConfigFunction> methods;

  /// 组件解析器
  final Map<String, FastConfigParserBuilder<Widget>> parsers;

  /// 装饰器解释器
  final Map<String, FastConfigParserBuilder<FastDecorate>> parserDecorates;

  /// 类型解释器
  final List<FastSchemeParser> parserValues;

  FastParser({
    required this.parsers,
    required this.parserDecorates,
    required this.data,
    required this.methods,
    required this.parserValues,
  });

  ///解析 配置
  Widget? decodeConfig(BuildContext context, Map<String, dynamic> config) {
    if (config.containsKey(FastKey.type)) {
      final ui = _parseConfigJson(
        context,
        config[FastKey.type],
        config,
        parsers,
      );

      return ui;
    }
    return null;
  }

  ///单独解析装饰器
  FastDecorate? decodeDecorateConfig(
      BuildContext context, Map<String, dynamic> config) {
    if (config.containsKey(FastKey.type)) {
      return _parseConfigJson(
        context,
        config[FastKey.type],
        config,
        parserDecorates,
      );
    }
    return null;
  }

  ///解析配置的单个组件的 json
  T? _parseConfigJson<T>(
    BuildContext context,
    String type,
    FastUIConfig config,
    Map<String, FastConfigParserBuilder<T>> parsers, {
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
        final parser = allParser[config[FastKey.type]]!;
        // 获取变量约束
        final scheme = parser.scheme[key];
        //解析值
        var result = value;
        if (value is List && key != FastKey.decorate) {
          result = _parserListValue(
              context, config, type, key, value, scheme, notifierValues);
        } else {
          result = _parserValue(context, config, type, key, value,
              parser.scheme[key], notifierValues);
        }

        ///转换组件
        if (result is List && key == FastKey.children) {
          result = result
              .map<T>((e) => _parseConfigJson<T>(
                    context,
                    e[FastKey.type],
                    e,
                    allParser,
                  )!)
              .toList();
        } else if (result is FastUIConfig &&
            key == FastKey.child &&
            result.containsKey(FastKey.type)) {
          result = _parseConfigJson<T>(
            context,
            result[FastKey.type],
            result,
            allParser,
          );
        }

        parsedConfig[key] = result;
      });

      if (T case Widget) {
        List<FastDecorate> decorates = [];
        //处理装饰器
        if (parsedConfig.containsKey(FastKey.decorate)) {
          decorates = _transformDecorateJson(
            context,
            parsedConfig,
          );
        }

        if (notifierValues.isNotEmpty && !skipNotifier) {
          decorates.add(
            FastValueBuilder(
              values: notifierValues.values.toList(),
              builder: (context, FastParser parser, _) {
                return _parseConfigJson<T>(
                  context,
                  type,
                  config,
                  parsers,
                  skipNotifier: true,
                ) as Widget;
              },
            ),
          );
        }
        //映射类型
        return decorates.applyAfterBuild(
          context,
          this,
          parser.builder(context, this, parsedConfig) as Widget,
        ) as T;
      } else if (T case FastDecorate) {
        if (notifierValues.isNotEmpty && !skipNotifier) {
          return FastValueBuilder(
            values: notifierValues.values.toList(),
            builder: (context, parser, child) {
              return (_parseConfigJson<T>(
                context,
                type,
                config,
                parsers,
                skipNotifier: true,
              ) as FastDecorate)
                  .build(context, parser, child);
            },
          ) as T;
        }
        //映射类型
        return parser.builder(context, this, parsedConfig);
      }
    }
    return null;
  }

  List<T> _parserListValue<T>(
    BuildContext context,
    FastUIConfig config,
    String type,
    String key,
    List<dynamic> value,
    FastScheme<T>? scheme,
    Map<String, ValueListenable> notifierValues,
  ) {
    List<T> data = value.map<T>((e) {
      return _parserValue<T>(
          context, config, type, key, e, scheme, notifierValues)!;
    }).toList();
    return data;
  }

  ///解析值
  T? _parserValue<T>(
    BuildContext context,
    FastUIConfig config,
    String type,
    String key,
    dynamic value,
    FastScheme<T>? scheme,
    Map<String, ValueListenable> notifierValues,
  ) {
    var result = value;

    // 解析变量和函数调用
    final (parsedResult, notifiers) = _parseDynamicMethodsAndVariable(
      context,
      value,
      scheme,
    );
    result = parsedResult;
    notifierValues.addAll(notifiers);

    //执行约束转换
    if (scheme != null) {
      result = _parserBySchemeValue(
        type,
        key,
        result,
        scheme,
      );
      return result;
    }
    return result;
  }

  ///解析一些动态变量和函数
  (T?, Map<String, ValueListenable>) _parseDynamicMethodsAndVariable<T>(
      BuildContext context, dynamic value, FastScheme<T>? scheme) {
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
                //TODO 函数中的变量是否需要监听，待后续思考
                // if (subValue != null) {
                //   allUseValues[subName!] = subValue;
                // }
                return subValue;
              }
              return e;
            }).toList();

            return (method(context, argsList), allUseValues);
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
  T? _parserBySchemeValue<T>(
      String type, String key, dynamic value, FastScheme<T> scheme) {
    if (scheme.defaultValue != null && value == null) {
      value = scheme.defaultValue;
    }
    final errMsg = "组件：$type , $key";
    assert(
      scheme.require == false || value != null,
      '$errMsg:为必填参数。',
    );

    final parserMethod = parserValues.safeFirstWhere(
      (element) => scheme.valueType == element?.valueType,
    );
    if (parserMethod != null) {
      try {
        return parserMethod.parserJson(value);
      } catch (e) {
        throw Exception("$errMsg:$e");
      }
    }
    return value;
  }

  /// 解析装饰器配置
  List<FastDecorate> _transformDecorateJson(
      BuildContext context, FastUIConfig config) {
    final decorates = config[FastKey.decorate];
    List<FastDecorate?> result = [];
    if (decorates != null && decorates is List && decorates.isNotEmpty) {
      result = decorates
          .map<FastDecorate?>((e) => decodeDecorateConfig(context, e))
          .toList();
    }
    return result.nonNulls.toList();
  }
}
