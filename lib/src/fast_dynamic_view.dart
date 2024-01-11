import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';

import 'view/base.dart';

/// 通过动态解码配置文件渲染一个组件

class FastDynamicView extends StatelessWidget {
  const FastDynamicView(
      {super.key, required this.config, this.data, this.methods});

  ///当前 View 的相关配置
  final Map<String, dynamic> config;

  ///当前 View 所具备的数据
  final Map<String, dynamic>? data;

  ///当前 View 所具备的函数
  final Map<String, Function>? methods;

  @override
  Widget build(BuildContext context) {
    //处理 动态数据
    final newData = data?.map((key, value) {
      if (key.startsWith(":") && value is! ValueNotifier) {
        if (value is String) {
          return MapEntry(key, ValueNotifier<String>(value));
        } else if (value is num) {
          return MapEntry(key, ValueNotifier<num>(value));
        } else if (value is bool) {
          return MapEntry(key, ValueNotifier<bool>(value));
        } else if (value is List) {
          return MapEntry(key, ValueNotifier<List>(value));
        } else if (value is Map) {
          return MapEntry(key, ValueNotifier<Map>(value));
        } else {
          return MapEntry(key, ValueNotifier(value));
        }
      }
      return MapEntry(key, value);
    });

    ///动态值转换
    final ui = FastUI.decodeConfig(
      context,
      config,
      data: newData,
      methods: methods,
    );

    if (ui != null) {
      return ui;
    }

    return const Placeholder();
  }
}
