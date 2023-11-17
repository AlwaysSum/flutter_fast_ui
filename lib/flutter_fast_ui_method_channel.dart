import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_fast_ui_platform_interface.dart';

/// An implementation of [FlutterFastUiPlatform] that uses method channels.
class MethodChannelFlutterFastUi extends FlutterFastUiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_fast_ui');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
