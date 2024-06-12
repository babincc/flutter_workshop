#ifndef FLUTTER_PLUGIN_FLUTTER_HUE_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_HUE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_hue {

class FlutterHuePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterHuePlugin();

  virtual ~FlutterHuePlugin();

  // Disallow copy and assign.
  FlutterHuePlugin(const FlutterHuePlugin&) = delete;
  FlutterHuePlugin& operator=(const FlutterHuePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_hue

#endif  // FLUTTER_PLUGIN_FLUTTER_HUE_PLUGIN_H_
