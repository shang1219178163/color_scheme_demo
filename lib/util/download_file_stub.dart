import 'package:flutter/foundation.dart';

/// 非 Web 平台占位：暂不支持自动下载
void downloadFile({required Uint8List bytes, required String fileName}) {
  debugPrint('downloadFile: 当前平台不支持自动下载 ($fileName, ${bytes.length} bytes)');
}
