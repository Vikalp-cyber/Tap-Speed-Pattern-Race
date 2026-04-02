import 'package:flutter/foundation.dart';

abstract final class AppLogger {
  static void info(String message) {
    debugPrint('[TapSpeed] $message');
  }
}
