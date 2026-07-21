import 'package:flutter/material.dart';

class AppThemeService {
  static final AppThemeService _instance = AppThemeService._();
  AppThemeService._();
  factory AppThemeService() => _instance;
  static AppThemeService get instance => _instance;

  final List<Color> colorOptions = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.cyan,
    Colors.deepPurple,
    Colors.lime,
    Colors.amber,
  ];

  Color seedColor = Colors.green;
  Brightness brightness = Brightness.light;

  /// 基于种子颜色和亮度生成配色方案（浅色 / 暗色分别适配）
  ColorScheme get colorScheme {
    final base = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    if (brightness == Brightness.light) {
      return base.copyWith(
        primary: seedColor,
        onPrimary: Colors.white,
        secondaryContainer: seedColor.withValues(alpha: 0.2),
        onSecondaryContainer: seedColor,
        error: Colors.red,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        inversePrimary: seedColor,
        outline: seedColor,
      );
    }
    // 暗黑模式：以 fromSeed 的表面色阶保证对比度，业务色与 surface 混合避免半透明失效
    return base.copyWith(
      primary: seedColor,
      onPrimary: resolveOnColor(seedColor),
      secondaryContainer: seedColor.withValues(alpha: 0.2),
      onSecondaryContainer: seedColor,
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      surface: Colors.black,
      onSurface: Colors.white,
      inversePrimary: lightenForDark(seedColor),
      outline: Color.alphaBlend(seedColor.withValues(alpha: 0.55), base.onSurface.withValues(alpha: 0.35)),
    );
  }

  /// 根据背景亮度选择可读前景色
  static Color resolveOnColor(Color background) {
    return ThemeData.estimateBrightnessForColor(background) == Brightness.dark ? Colors.white : Colors.black;
  }

  /// 暗色模式下提高种子色明度，保证容器前景可读
  static Color lightenForDark(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + 0.28).clamp(0.45, 0.85)).toColor();
  }
}
