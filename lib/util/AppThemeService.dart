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

  // 基于种子颜色和亮度生成配色方案
  ColorScheme get colorScheme => ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
        primary: seedColor,
        onPrimary: Colors.white, // 主色上的文字
        secondary: Colors.orangeAccent, // 辅助色
        onSecondary: Colors.purple,
        error: Colors.white, // 错误色
        onError: Colors.red,
        surface: Color(0xfff6f6f6), // 卡片/底部区域
        onSurface: Color(0xff181818),
        outline: seedColor,
        // outlineVariant: Colors.blue,
      );
}
