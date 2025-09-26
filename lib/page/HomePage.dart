import 'package:flutter/material.dart';

import '../util/ThemeManager.dart';
import '../widget/seed_color_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SeedColorMixin {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ColorScheme 配色方案生成器'),
          backgroundColor: ThemeManager.instance.colorScheme.primary,
          foregroundColor: ThemeManager.instance.colorScheme.onPrimary,
          elevation: 4,
          actions: [
            // IconButton(
            //   icon: Icon(_brightness == Brightness.light ? Icons.dark_mode : Icons.light_mode),
            //   onPressed: () {
            //     setState(() {
            //       _brightness = _brightness == Brightness.light ? Brightness.dark : Brightness.light;
            //     });
            //   },
            // ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 颜色选择器
              SeedColorBox(
                onColorChanged: (v) {
                  setState(() {});
                  debugPrint("onColorChanged $v");
                },
                onBrightnessChanged: (v) {
                  setState(() {});
                  debugPrint("onBrightnessChanged $v");
                },
              ),
              const SizedBox(height: 24),

              // 配色方案展示
              _buildColorSchemeDisplay(colorScheme),
              const SizedBox(height: 24),

              // UI 组件示例
              _buildComponentExamples(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorSchemeDisplay(ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '配色方案详情',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // 主要颜色
            _buildColorItem('primary', colorScheme.primary, colorScheme.onPrimary),
            _buildColorItem('onPrimary', colorScheme.onPrimary, colorScheme.primary),
            _buildColorItem('primaryContainer', colorScheme.primaryContainer, colorScheme.onPrimaryContainer),
            _buildColorItem('onPrimaryContainer', colorScheme.onPrimaryContainer, colorScheme.primaryContainer),

            // 次要颜色
            _buildColorItem('secondary', colorScheme.secondary, colorScheme.onSecondary),
            _buildColorItem('onSecondary', colorScheme.onSecondary, colorScheme.secondary),
            _buildColorItem('secondaryContainer', colorScheme.secondaryContainer, colorScheme.onSecondaryContainer),
            _buildColorItem('onSecondaryContainer', colorScheme.onSecondaryContainer, colorScheme.secondaryContainer),

            // 三级颜色
            _buildColorItem('tertiary', colorScheme.tertiary, colorScheme.onTertiary),
            _buildColorItem('onTertiary', colorScheme.onTertiary, colorScheme.tertiary),
            _buildColorItem('tertiaryContainer', colorScheme.tertiaryContainer, colorScheme.onTertiaryContainer),
            _buildColorItem('onTertiaryContainer', colorScheme.onTertiaryContainer, colorScheme.tertiaryContainer),

            // 表面颜色
            _buildColorItem('surface', colorScheme.surface, colorScheme.onSurface),
            _buildColorItem('onSurface', colorScheme.onSurface, colorScheme.surface),
            _buildColorItem('surfaceVariant', colorScheme.surfaceVariant, colorScheme.onSurfaceVariant),
            _buildColorItem('onSurfaceVariant', colorScheme.onSurfaceVariant, colorScheme.surfaceVariant),

            // 背景颜色
            _buildColorItem('background', colorScheme.background, colorScheme.onBackground),
            _buildColorItem('onBackground', colorScheme.onBackground, colorScheme.background),

            // 错误颜色
            _buildColorItem('error', colorScheme.error, colorScheme.onError),
            _buildColorItem('onError', colorScheme.onError, colorScheme.error),
            _buildColorItem('errorContainer', colorScheme.errorContainer, colorScheme.onErrorContainer),
            _buildColorItem('onErrorContainer', colorScheme.onErrorContainer, colorScheme.errorContainer),

            // 轮廓颜色
            _buildColorItem('outline', colorScheme.outline, colorScheme.background),
            _buildColorItem('outlineVariant', colorScheme.outlineVariant, colorScheme.background),

            // 阴影颜色
            _buildColorItem('shadow', colorScheme.shadow, Colors.white),

            // 表面色调颜色
            _buildColorItem('surfaceTint', colorScheme.surfaceTint, Colors.white),

            // 反转表面颜色
            _buildColorItem('inverseSurface', colorScheme.inverseSurface, colorScheme.onInverseSurface),
            _buildColorItem('onInverseSurface', colorScheme.onInverseSurface, colorScheme.inverseSurface),

            // 主要颜色反转
            _buildColorItem('inversePrimary', colorScheme.inversePrimary, colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildColorItem(String name, Color color, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
            style: TextStyle(
              color: textColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentExamples(ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UI 组件示例',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // 按钮示例
            Text(
              '按钮',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('主要按钮'),
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('填充按钮'),
                ),
                FilledButton.tonal(
                  onPressed: () {},
                  child: const Text('色调按钮'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('轮廓按钮'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('文本按钮'),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 卡片示例
            Text(
              '卡片',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '卡片标题',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '这是一个使用当前配色方案的卡片示例。',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 输入框示例
            Text(
              '输入框',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: '用户名',
                hintText: '请输入用户名',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: '密码',
                hintText: '请输入密码',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // 选择控件示例
            Text(
              '选择控件',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (value) {},
                ),
                const Text('复选框'),
                const SizedBox(width: 16),
                Switch(
                  value: true,
                  onChanged: (value) {},
                ),
                const Text('开关'),
                const SizedBox(width: 16),
                Radio(
                  value: 1,
                  groupValue: 1,
                  onChanged: (value) {},
                ),
                const Text('单选'),
              ],
            ),
            const SizedBox(height: 16),

            // 进度指示器示例
            Text(
              '进度指示器',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.7,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            const SizedBox(height: 12),
            CircularProgressIndicator(
              value: 0.7,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ],
        ),
      ),
    );
  }
}
