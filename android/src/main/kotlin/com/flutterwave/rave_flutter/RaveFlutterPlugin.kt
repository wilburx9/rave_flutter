package com.flutterwave.rave_flutter

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class RaveFlutterPlugin: MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "rave_flutter")
      channel.setMethodCallHandler(RaveFlutterPlugin())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    result.notImplemented()
  }
}
