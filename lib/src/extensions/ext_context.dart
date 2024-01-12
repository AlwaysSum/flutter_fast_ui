import 'package:flutter/cupertino.dart';

typedef ResponsiveBuilderFunction = Widget? Function(Widget? child);

extension FastExtBuildContext on BuildContext {
  /// 自适应组件
  Widget? responsive(
    Widget? child, {
    required ResponsiveBuilderFunction init,
    ResponsiveBuilderFunction? pc,
    ResponsiveBuilderFunction? tablet,
    ResponsiveBuilderFunction? phone,
    int tabletSize = 1280,
    int pcSize = 720,
    int phoneSize = 360,
  }) {
    final width = MediaQuery.of(this).size.width;
    if (width > pcSize) {
      return (pc ?? init)(child);
    } else if (width > tabletSize) {
      return (tablet ?? init)(child);
    } else if (width > phoneSize) {
      return (tablet ?? init)(child);
    } else {
      return init(child);
    }
  }
}
