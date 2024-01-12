import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/src/parser/fast_sys_methods.dart';

import '../flutter_fast_ui_platform_interface.dart';
import 'decorates/base.dart';
import 'parser/fast_parser.dart';
import 'parser/fast_sys_parser.dart';
import 'types.dart';

/// FAST UI
///
class FastUI {
  static final _systemParser = FastSystemParser();
  static final _systemMethods = FastSysMethods();

  ///一些自定义的解析器
  static final Map<String, FastConfigParserBuilder<Widget>> customParser = {};
  static final Map<String, FastConfigParserBuilder<FastDecorate>>
      customDecorateParser = {};
  static final Map<String, Function> customMethodsParser = {};
  static final Map<String, dynamic> customDataParser = {};

  Future<String?> getPlatformVersion() {
    return FlutterFastUiPlatform.instance.getPlatformVersion();
  }

  ///解析 配置
  static Widget? decodeConfig(
    BuildContext context,
    Map<String, dynamic> config, {
    Map<String, dynamic>? data,
    Map<String, Function>? methods,
  }) {
    final ui = getParser(data, methods).decodeConfig(context, config);
    return ui;
  }

  ///单独解析装饰器
  static FastDecorate? decodeDecorateConfig(
    BuildContext context,
    Map<String, dynamic> config, {
    Map<String, dynamic>? data,
    Map<String, Function>? methods,
  }) {
    final ui = getParser(data, methods).decodeDecorateConfig(context, config);
    return ui;
  }

  ///获取解析器
  static FastParser getParser(
    Map<String, dynamic>? data,
    Map<String, Function>? methods,
  ) {
    return FastParser(
      parsers: {..._systemParser.parser, ...customParser},
      parserDecorates: {
        ..._systemParser.parserDecorate,
        ...customDecorateParser
      },
      data: {
        ...customDataParser,
        ...(data ?? {}),
      },
      methods: {
        ..._systemMethods.methods,
        ...(methods ?? {}),
      },
    );
  }

  /// 添加解析器
  static addWidgetParser(Map<String, FastConfigParserBuilder<Widget>> parser) {
    customParser.addAll(parser);
  }

  /// 添加装饰器解析器
  static addDecorateParser(
      Map<String, FastConfigParserBuilder<FastDecorate>> parser) {
    customDecorateParser.addAll(parser);
  }

  /// 添加全局函数
  static addMethodsParser(Map<String, Function> parser) {
    customMethodsParser.addAll(parser);
  }

  /// 添加全局函数
  static addDataParser(Map<String, dynamic> data) {
    customDataParser.addAll(data);
  }
}
