import 'package:color_scheme_demo/util/ThemeManager.dart';
import 'package:flutter/material.dart';

class SeedColorBox extends StatefulWidget {
  const SeedColorBox({
    super.key,
    this.onColorChanged,
    this.onBrightnessChanged,
  });

  final ValueChanged<Color>? onColorChanged;
  final ValueChanged<Brightness>? onBrightnessChanged;

  @override
  State<SeedColorBox> createState() => _SeedColorBoxState();
}

class _SeedColorBoxState extends State<SeedColorBox> {
  @override
  void didUpdateWidget(covariant SeedColorBox oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '选择种子颜色',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  icon: Icon(ThemeManager.instance.brightness == Brightness.light ? Icons.dark_mode : Icons.light_mode),
                  onPressed: () {
                    ThemeManager.instance.brightness =
                        ThemeManager.instance.brightness == Brightness.light ? Brightness.dark : Brightness.light;
                    setState(() {});
                    widget.onBrightnessChanged?.call(ThemeManager.instance.brightness);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ThemeManager.instance.colorOptions.map((color) {
                return GestureDetector(
                  onTap: () {
                    ThemeManager.instance.seedColor = color;
                    setState(() {});
                    widget.onColorChanged?.call(color);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: ThemeManager.instance.seedColor.value == color.value
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 3,
                            )
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Text(
              '当前种子颜色: ${ThemeManager.instance.seedColor.toString()}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '当前模式: ${ThemeManager.instance.brightness == Brightness.light ? '浅色模式' : '深色模式'}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

mixin SeedColorMixin<T extends StatefulWidget> on State<T> {
  /// 仅读
  ColorScheme get colorScheme => ThemeManager.instance.colorScheme;

  /// 选择主题
  void showSeedColorPicker({bool dismiss = true}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        minHeight: 200,
        maxHeight: 500,
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                SeedColorBox(
                  onColorChanged: (v) {
                    setState(() {});
                    if (dismiss) {
                      Navigator.of(context).pop();
                    }
                    debugPrint("onColorChanged $v");
                  },
                  onBrightnessChanged: (v) {
                    setState(() {});
                    if (dismiss) {
                      Navigator.of(context).pop();
                    }
                    debugPrint("onBrightnessChanged $v");
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
