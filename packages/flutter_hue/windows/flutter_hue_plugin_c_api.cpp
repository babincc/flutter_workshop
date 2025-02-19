#include "include/flutter_hue/flutter_hue_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_hue_plugin.h"

void FlutterHuePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_hue::FlutterHuePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
