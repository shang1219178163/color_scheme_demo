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

  /// 辅助色（M3 组件多走 secondaryContainer，需与 secondary 同源配置才会生效）
  static const Color secondaryColor = Colors.orangeAccent;
  static const Color onSecondaryColor = Colors.white;

  // 基于种子颜色和亮度生成配色方案
  ColorScheme get colorScheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      primary: seedColor,
      onPrimary: Colors.white,
      // secondary: secondaryColor,
      // onSecondary: onSecondaryColor,
      // M3 Chip / SegmentedButton / tonal / 导航指示器使用 Container 系列
      secondaryContainer: Color.alphaBlend(secondaryColor.withValues(alpha: 0.28), const Color(0xfff6f6f6)),
      onSecondaryContainer: const Color(0xFFE65100),
      error: Colors.white,
      onError: Colors.red,
      surface: const Color(0xfff6f6f6),
      onSurface: const Color(0xff181818),
      outline: seedColor,
    );
    return scheme;
  }
}
