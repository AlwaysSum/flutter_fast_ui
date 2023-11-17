#include "include/flutter_fast_ui/flutter_fast_ui_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_fast_ui_plugin.h"

void FlutterFastUiPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_fast_ui::FlutterFastUiPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
