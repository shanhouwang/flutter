import 'package:flutter/services.dart';

class AndroidBridge {
  static const platform = MethodChannel('flutter_to_android');

  /// 返回到 Android 页面
  static void goBack() {
    platform.invokeMethod('goBack');
  }
}