import 'package:flutter/material.dart';

import '../types.dart';

///一些系统预设函数
class FastSysMethods {
  Map<String, FastConfigFunction> methods = {
    "set": (BuildContext context, List args) {
      final [ValueNotifier data, value] = args;
      return () {
        if (data.value is num) {
          final newValue = num.parse(value);
          data.value = newValue;
          data.notifyListeners();
        } else {
          data.value = value;
          data.notifyListeners();
        }
      };
    },
    "add": (BuildContext context, List args) {
      final [ValueNotifier data, String value] = args;
      return () {
        if (data.value is num) {
          final newValue = num.parse(value);
          data.value = data.value + newValue;
          data.notifyListeners();
        } else {
          data.value = data.value + value;
          data.notifyListeners();
        }
      };
    }
  };
}
