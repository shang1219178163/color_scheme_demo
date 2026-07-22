import 'dart:typed_data';

import 'download_file_stub.dart' if (dart.library.js_interop) 'download_file_web.dart' as impl;

/// 触发浏览器下载（Web）；其他平台见 stub 实现
void downloadFile({required Uint8List bytes, required String fileName}) {
  impl.downloadFile(bytes: bytes, fileName: fileName);
}
