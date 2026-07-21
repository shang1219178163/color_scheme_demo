import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'download_file.dart';

/// 将 [RepaintBoundary] 截成 PNG 并触发下载
Future<void> captureAndDownloadWidget({
  required GlobalKey captureKey,
  required BuildContext context,
  double? pixelRatio,
}) async {
  final boundary = captureKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) {
    showCaptureMessage(context, '截图失败：未找到可截取区域');
    return;
  }
  if (boundary.debugNeedsPaint) {
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
  if (!context.mounted) {
    return;
  }
  final ratio = pixelRatio ?? MediaQuery.devicePixelRatioOf(context);
  final image = await boundary.toImage(pixelRatio: ratio);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  if (!context.mounted) {
    return;
  }
  if (byteData == null) {
    showCaptureMessage(context, '截图失败：无法编码图片');
    return;
  }
  final bytes = byteData.buffer.asUint8List();
  final fileName = 'color_scheme_${DateTime.now().millisecondsSinceEpoch}.png';
  downloadFile(bytes: bytes, fileName: fileName);
  showCaptureMessage(context, '已生成并下载 $fileName');
}

void showCaptureMessage(BuildContext context, String message) {
  if (!context.mounted) {
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
