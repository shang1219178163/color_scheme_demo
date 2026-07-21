import 'dart:html' as html;
import 'dart:typed_data';

/// Web：用 Blob + a[download] 触发浏览器下载
void downloadFile({required Uint8List bytes, required String fileName}) {
  final blob = html.Blob([bytes], 'image/png');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();
  html.Url.revokeObjectUrl(url);
}
