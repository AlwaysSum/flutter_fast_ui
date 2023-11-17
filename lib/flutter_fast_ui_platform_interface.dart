import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_fast_ui_method_channel.dart';

abstract class FlutterFastUiPlatform extends PlatformInterface {
  /// Constructs a FlutterFastUiPlatform.
  FlutterFastUiPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterFastUiPlatform _instance = MethodChannelFlutterFastUi();

  /// The default instance of [FlutterFastUiPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterFastUi].
  static FlutterFastUiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterFastUiPlatform] when
  /// they register themselves.
  static set instance(FlutterFastUiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
