import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/src/parser/fast_sys_methods.dart';

import '../flutter_fast_ui_platform_interface.dart';
import 'decorates/base.dart';
import 'parser/fast_parser.dart';
import 'parser/fast_sys_parser.dart';

class FastUI {
  static final systemParser = FastSystemParser();
  static final systemMethods = FastSysMethods();

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
    final ui = FastParser(
      parsers: systemParser.parser,
      parserDecorates: systemParser.parserDecorate,
      data: data ?? {},
      methods: (methods ?? {})?..addAll(systemMethods.methods),
    ).decodeConfig(context, config);
    return ui;
  }

  ///单独解析装饰器
  static FastDecorate? decodeDecorateConfig(
    BuildContext context,
    Map<String, dynamic> config, {
    Map<String, dynamic>? data,
    Map<String, Function>? methods,
  }) {
    final ui = FastParser(
      parsers: systemParser.parser,
      parserDecorates: systemParser.parserDecorate,
      data: data ?? {},
      methods: (methods ?? {})?..addAll(systemMethods.methods),
    ).decodeDecorateConfig(context, config);
    return ui;
  }
}
