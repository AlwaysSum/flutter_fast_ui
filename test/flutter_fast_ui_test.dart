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
}
