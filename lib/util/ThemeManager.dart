import 'package:flutter/material.dart';

class ThemeManager {
  static final ThemeManager _instance = ThemeManager._();
  ThemeManager._();
  factory ThemeManager() => _instance;
  static ThemeManager get instance => _instance;

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

  Color seedColor = Colors.blue;
  Brightness brightness = Brightness.light;

  // 基于种子颜色和亮度生成配色方案
  ColorScheme get colorScheme => ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      );
}
