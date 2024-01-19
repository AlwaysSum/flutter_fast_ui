import 'package:flutter/material.dart';

import '../../flutter_fast_ui.dart';
import '../utils/utils_value.dart';

class FastSchemeEdgeInsetsParser extends FastSchemeParser<EdgeInsets> {
  @override
  EdgeInsets? parserJson(value) {
    if(value == null){
      return null;
    }else if (value is num) {
      return EdgeInsets.all(value.toDouble());
    } else if (value is Map<String, double>) {
      if (value.containsKey('vertical') || value.containsKey('horizontal')) {
        return EdgeInsets.symmetric(
          vertical: value['vertical'] ?? 0,
          horizontal: value['horizontal'] ?? 0,
        );
      } else {
        return EdgeInsets.only(
          left: value['left'] ?? 0,
          right: value['right'] ?? 0,
          top: value['top'] ?? 0,
          bottom: value['bottom'] ?? 0,
        );
      }
    } else {
      return EdgeInsets.zero;
    }
  }
}
