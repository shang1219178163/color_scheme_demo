import 'package:color_scheme_demo/util/AppRouter.dart';
import 'package:color_scheme_demo/util/page_capture.dart';
import 'package:flutter/material.dart';

import '../widget/seed_color_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SeedColorMixin {
  final GlobalKey _pageCaptureKey = GlobalKey();
  bool _isCapturing = false;

  Future<void> capturePage() async {
    if (_isCapturing) {
      return;
    }
    setState(() {
      _isCapturing = true;
    });
    try {
      await captureAndDownloadWidget(captureKey: _pageCaptureKey, context: context);
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: colorScheme,
        brightness: colorScheme.brightness,
        useMaterial3: true,
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        cardColor: colorScheme.surfaceContainerLow,
        dividerColor: colorScheme.outlineVariant,
        applyElevationOverlayColor: colorScheme.brightness == Brightness.dark,
      ),
      child: SelectionArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('ColorScheme 配色方案生成器'),
            elevation: 4,
            actions: [
              IconButton(
                tooltip: '截取整页并下载',
                onPressed: _isCapturing ? null : capturePage,
                icon: _isCapturing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.crop),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () async {
                  final result = await AppNavigator.toNamed(AppRouter.morePage, arguments: {"id": "111", "a": "999"});
                  DLog.d("$widget: $result");
                },
              ),
              IconButton(
                icon: const Icon(Icons.color_lens),
                onPressed: () async {
                  AppNavigator.toNamed(AppRouter.testPage);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: RepaintBoundary(
              key: _pageCaptureKey,
              child: ColoredBox(
                color: colorScheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    buildColorSchemeDisplay(colorScheme),
                    const SizedBox(height: 24),
                    buildComponentExamples(colorScheme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildColorSchemeDisplay(ColorScheme colorScheme) {
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
            buildColorItem('primary', colorScheme.primary, colorScheme.onPrimary),
            buildColorItem('onPrimary', colorScheme.onPrimary, colorScheme.primary),
            buildColorItem('primaryContainer', colorScheme.primaryContainer, colorScheme.onPrimaryContainer),
            buildColorItem('onPrimaryContainer', colorScheme.onPrimaryContainer, colorScheme.primaryContainer),

            // 次要颜色
            buildColorItem('secondary', colorScheme.secondary, colorScheme.onSecondary),
            buildColorItem('onSecondary', colorScheme.onSecondary, colorScheme.secondary),
            buildColorItem('secondaryContainer', colorScheme.secondaryContainer, colorScheme.onSecondaryContainer),
            buildColorItem('onSecondaryContainer', colorScheme.onSecondaryContainer, colorScheme.secondaryContainer),

            // 三级颜色
            buildColorItem('tertiary', colorScheme.tertiary, colorScheme.onTertiary),
            buildColorItem('onTertiary', colorScheme.onTertiary, colorScheme.tertiary),
            buildColorItem('tertiaryContainer', colorScheme.tertiaryContainer, colorScheme.onTertiaryContainer),
            buildColorItem('onTertiaryContainer', colorScheme.onTertiaryContainer, colorScheme.tertiaryContainer),

            // 表面颜色
            buildColorItem('surface', colorScheme.surface, colorScheme.onSurface),
            buildColorItem('onSurface', colorScheme.onSurface, colorScheme.surface),
            buildColorItem('surfaceVariant', colorScheme.surfaceContainerHighest, colorScheme.onSurfaceVariant),
            buildColorItem('onSurfaceVariant', colorScheme.onSurfaceVariant, colorScheme.surfaceContainerHighest),

            // 背景颜色
            buildColorItem('background', colorScheme.surface, colorScheme.onSurface),
            buildColorItem('onBackground', colorScheme.onSurface, colorScheme.surface),

            // 错误颜色
            buildColorItem('error', colorScheme.error, colorScheme.onError),
            buildColorItem('onError', colorScheme.onError, colorScheme.error),
            buildColorItem('errorContainer', colorScheme.errorContainer, colorScheme.onErrorContainer),
            buildColorItem('onErrorContainer', colorScheme.onErrorContainer, colorScheme.errorContainer),

            // 轮廓颜色
            buildColorItem('outline', colorScheme.outline, colorScheme.surface),
            buildColorItem('outlineVariant', colorScheme.outlineVariant, colorScheme.surface),

            // 阴影颜色
            buildColorItem('shadow', colorScheme.shadow, Colors.white),

            // 表面色调颜色
            buildColorItem('surfaceTint', colorScheme.surfaceTint, Colors.white),

            // 反转表面颜色
            buildColorItem('inverseSurface', colorScheme.inverseSurface, colorScheme.onInverseSurface),
            buildColorItem('onInverseSurface', colorScheme.onInverseSurface, colorScheme.inverseSurface),

            // 主要颜色反转
            buildColorItem('inversePrimary', colorScheme.inversePrimary, colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget buildColorItem(String name, Color color, Color textColor) {
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

  /// 按 ColorScheme 属性分组展示相关 Material 组件
  /// 按 ColorScheme 属性分组展示相关 Material 组件（颜色全部走主题，不二次赋值）
  Widget buildComponentExamples(ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'UI 组件示例（颜色走主题 ColorScheme）',
            ),
            const SizedBox(height: 16),
            buildSchemeSection(
              title: 'primary',
              swatchColor: colorScheme.primary,
              subtitle: 'FilledButton、Text/Outlined 文字、IconButton.filled、Switch、Checkbox、Slider、ProgressIndicator',
              colorScheme: colorScheme,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FilledButton(onPressed: () {}, child: const Text('FilledButton')),
                      FilledButton.icon(
                          onPressed: () {}, icon: const Icon(Icons.check), label: const Text('Filled.icon')),
                      TextButton(onPressed: () {}, child: const Text('TextButton')),
                      TextButton.icon(onPressed: () {}, icon: const Icon(Icons.info), label: const Text('Text.icon')),
                      OutlinedButton(onPressed: () {}, child: const Text('OutlinedButton')),
                      OutlinedButton.icon(
                          onPressed: () {}, icon: const Icon(Icons.link), label: const Text('Outlined.icon')),
                      IconButton.filled(onPressed: () {}, icon: const Icon(Icons.favorite)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Switch(value: true, onChanged: (_) {}),
                      Checkbox(value: true, onChanged: (_) {}),
                      Radio(value: 1, groupValue: 1, onChanged: (_) {}),
                      SizedBox(width: 120, child: Slider(value: 0.6, onChanged: (_) {})),
                      const SizedBox(width: 100, child: LinearProgressIndicator(value: 0.7)),
                      const SizedBox(
                          width: 28, height: 28, child: CircularProgressIndicator(value: 0.7, strokeWidth: 3)),
                    ],
                  ),
                ],
              ),
            ),
            buildSchemeSection(
              title: 'onPrimary',
              swatchColor: colorScheme.onPrimary,
              subtitle: 'primary 填充组件上的文本、Icon（见 FilledButton）',
              colorScheme: colorScheme,
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle),
                label: const Text('onPrimary 文本与图标'),
              ),
            ),
            buildSchemeSection(
              title: 'primaryContainer',
              swatchColor: colorScheme.primaryContainer,
              subtitle: 'FAB 背景（M3 默认）',
              colorScheme: colorScheme,
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FloatingActionButton.small(
                    heroTag: 'fab_primary_container_small',
                    onPressed: () {},
                    child: const Icon(Icons.add),
                  ),
                  FloatingActionButton(
                    heroTag: 'fab_primary_container',
                    onPressed: () {},
                    child: const Icon(Icons.add),
                  ),
                  FloatingActionButton.extended(
                    heroTag: 'fab_primary_container_extended',
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('FAB'),
                  ),
                ],
              ),
            ),
            buildSchemeSection(
              title: 'onPrimaryContainer',
              swatchColor: colorScheme.onPrimaryContainer,
              subtitle: 'FAB 图标/文字（随 primaryContainer）',
              colorScheme: colorScheme,
              child: FloatingActionButton.extended(
                heroTag: 'fab_on_primary_container',
                onPressed: () {},
                icon: const Icon(Icons.palette),
                label: const Text('onPrimaryContainer'),
              ),
            ),
            buildSchemeSection(
              title: 'secondary',
              swatchColor: colorScheme.secondary,
              subtitle: 'ColorScheme.secondary；M3 组件默认多用 secondaryContainer',
              colorScheme: colorScheme,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ChoiceChip(label: const Text('ChoiceChip'), selected: true, onSelected: (_) {}),
                      ChoiceChip(label: const Text('未选中'), selected: false, onSelected: (_) {}),
                      FilterChip(label: const Text('FilterChip'), selected: true, onSelected: (_) {}),
                      ActionChip(
                          avatar: const Icon(Icons.bolt, size: 18), label: const Text('ActionChip'), onPressed: () {}),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 0, label: Text('日'), icon: Icon(Icons.calendar_view_day)),
                      ButtonSegment(value: 1, label: Text('周'), icon: Icon(Icons.calendar_view_week)),
                      ButtonSegment(value: 2, label: Text('月'), icon: Icon(Icons.calendar_view_month)),
                    ],
                    selected: const {0},
                    onSelectionChanged: (_) {},
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: NavigationRail(
                      selectedIndex: 0,
                      onDestinationSelected: (_) {},
                      labelType: NavigationRailLabelType.selected,
                      destinations: const [
                        NavigationRailDestination(icon: Icon(Icons.home), label: Text('首页')),
                        NavigationRailDestination(icon: Icon(Icons.search), label: Text('搜索')),
                        NavigationRailDestination(icon: Icon(Icons.person), label: Text('我的')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  NavigationBar(
                    selectedIndex: 0,
                    onDestinationSelected: (_) {},
                    destinations: const [
                      NavigationDestination(icon: Icon(Icons.home), label: '首页'),
                      NavigationDestination(icon: Icon(Icons.explore), label: '发现'),
                      NavigationDestination(icon: Icon(Icons.settings), label: '设置'),
                    ],
                  ),
                ],
              ),
            ),
            buildSchemeSection(
              title: 'onSecondary',
              swatchColor: colorScheme.onSecondary,
              subtitle: 'secondary 选中态上的文字/图标（Chip、SegmentedButton）',
              colorScheme: colorScheme,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(label: const Text('onSecondary 文字'), selected: true, onSelected: (_) {}),
                      FilterChip(label: const Text('选中态前景'), selected: true, onSelected: (_) {}),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 0, label: Text('选项 A')),
                      ButtonSegment(value: 1, label: Text('选项 B')),
                    ],
                    selected: const {0},
                    onSelectionChanged: (_) {},
                    showSelectedIcon: false,
                  ),
                ],
              ),
            ),
            buildSchemeSection(
              title: 'secondaryContainer',
              swatchColor: colorScheme.secondaryContainer,
              subtitle: 'FilledButton.tonal、IconButton.filledTonal（M3 默认 token）',
              colorScheme: colorScheme,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilledButton.tonal(onPressed: () {}, child: const Text('FilledButton.tonal')),
                  FilledButton.tonalIcon(
                      onPressed: () {}, icon: const Icon(Icons.edit), label: const Text('Tonal.icon')),
                  IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.favorite)),
                ],
              ),
            ),
            buildSchemeSection(
              title: 'onSecondaryContainer',
              swatchColor: colorScheme.onSecondaryContainer,
              subtitle: 'tonal 按钮前景色',
              colorScheme: colorScheme,
              child: FilledButton.tonalIcon(
                onPressed: () {},
                icon: const Icon(Icons.tune),
                label: const Text('onSecondaryContainer'),
              ),
            ),
            buildSchemeSection(
              title: 'tertiary',
              swatchColor: colorScheme.tertiary,
              subtitle: '第三强调色；M3 少有默认组件直出，左侧色块即主题值',
              colorScheme: colorScheme,
              child: Text(
                '无默认 Material 组件绑定 tertiary，需业务侧通过 Theme 扩展使用',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            buildSchemeSection(
              title: 'surface',
              swatchColor: colorScheme.surface,
              subtitle: 'Scaffold、Card、Dialog、BottomSheet',
              colorScheme: colorScheme,
              child: Column(
                children: [
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.layers),
                      title: Text('默认 Card'),
                      subtitle: Text('背景走 surface'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilledButton.tonal(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Dialog'),
                              content: const Text('背景走主题 surface'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('关闭')),
                              ],
                            ),
                          );
                        },
                        child: const Text('打开 Dialog'),
                      ),
                      FilledButton.tonal(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => const Padding(
                              padding: EdgeInsets.all(24),
                              child: Text('BottomSheet 背景走主题 surface'),
                            ),
                          );
                        },
                        child: const Text('打开 BottomSheet'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            buildSchemeSection(
              title: 'onSurface',
              swatchColor: colorScheme.onSurface,
              subtitle: '普通正文、主图标',
              colorScheme: colorScheme,
              child: const Row(
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(width: 8),
                  Text('普通正文与图标（默认 onSurface）'),
                ],
              ),
            ),
            buildSchemeSection(
              title: 'onSurfaceVariant',
              swatchColor: colorScheme.onSurfaceVariant,
              subtitle: '次要文本、辅助图标',
              colorScheme: colorScheme,
              child: const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.folder),
                title: Text('主标题'),
                subtitle: Text('副标题默认偏 onSurfaceVariant'),
              ),
            ),
            buildSchemeSection(
              title: 'surfaceContainer',
              swatchColor: colorScheme.surfaceContainer,
              subtitle: 'NavigationBar 背景等',
              colorScheme: colorScheme,
              child: NavigationBar(
                selectedIndex: 0,
                onDestinationSelected: (_) {},
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home), label: '首页'),
                  NavigationDestination(icon: Icon(Icons.explore), label: '发现'),
                  NavigationDestination(icon: Icon(Icons.settings), label: '设置'),
                ],
              ),
            ),
            buildSchemeSection(
              title: 'surfaceContainerLow',
              swatchColor: colorScheme.surfaceContainerLow,
              subtitle: 'ElevatedButton 背景、Chip 未选中',
              colorScheme: colorScheme,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text('ElevatedButton')),
                  ElevatedButton.icon(
                      onPressed: () {}, icon: const Icon(Icons.send), label: const Text('Elevated.icon')),
                  ChoiceChip(label: const Text('未选中 Chip'), selected: false, onSelected: (_) {}),
                ],
              ),
            ),
            buildSchemeSection(
              title: 'outline',
              swatchColor: colorScheme.outline,
              subtitle: 'OutlinedButton 边框、TextField、IconButton.outlined',
              colorScheme: colorScheme,
              child: Column(
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton(onPressed: () {}, child: const Text('OutlinedButton')),
                      IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.favorite)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'TextField',
                      hintText: '边框走主题 outline',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            buildSchemeSection(
              title: 'outlineVariant',
              swatchColor: colorScheme.outlineVariant,
              subtitle: 'Divider（M3 默认）',
              colorScheme: colorScheme,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('分割线走 outlineVariant'),
                  Divider(),
                ],
              ),
            ),
            buildSchemeSection(
              title: 'error',
              swatchColor: colorScheme.error,
              subtitle: 'ErrorText、Error Border、Badge',
              colorScheme: colorScheme,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Badge(label: Text('3'), child: Icon(Icons.notifications)),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      labelText: '邮箱',
                      errorText: 'Error 样式走主题 error',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            buildSchemeSection(
              title: 'onError',
              swatchColor: colorScheme.onError,
              subtitle: 'Badge 等内容在 error 上的前景',
              colorScheme: colorScheme,
              child: const Badge(label: Text('onError'), child: Icon(Icons.notifications)),
            ),
            buildSchemeSection(
              title: 'errorContainer / onErrorContainer',
              swatchColor: colorScheme.errorContainer,
              subtitle: '错误提示容器色；需业务 Theme 扩展时使用，左侧色块即主题值',
              colorScheme: colorScheme,
              child: Text(
                '无默认组件直出 errorContainer，可通过 InputDecorator / 自定义 Banner 扩展',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            buildSchemeSection(
              title: 'shadow',
              swatchColor: colorScheme.shadow,
              subtitle: 'Material elevation 阴影',
              colorScheme: colorScheme,
              child: const Card(
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Card elevation 阴影走主题 shadow'),
                ),
              ),
            ),
            buildSchemeSection(
              title: 'scrim',
              swatchColor: colorScheme.scrim,
              subtitle: 'Dialog / Drawer / BottomSheet 遮罩',
              colorScheme: colorScheme,
              child: FilledButton.tonal(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('观察遮罩'),
                      content: const Text('周围半透明层即为主题 scrim'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('关闭')),
                      ],
                    ),
                  );
                },
                child: const Text('打开 Dialog 查看 scrim'),
              ),
            ),
            buildSchemeSection(
              title: 'inverseSurface / onInverseSurface',
              swatchColor: colorScheme.inverseSurface,
              subtitle: 'SnackBar 背景与内容文字',
              colorScheme: colorScheme,
              child: FilledButton.tonal(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('SnackBar 背景/文字走主题 inverseSurface')),
                  );
                },
                child: const Text('显示 SnackBar'),
              ),
            ),
            buildSchemeSection(
              title: 'inversePrimary',
              swatchColor: colorScheme.inversePrimary,
              subtitle: 'SnackBar Action 强调色',
              colorScheme: colorScheme,
              child: FilledButton.tonal(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('消息已保存'),
                      action: SnackBarAction(label: '撤销', onPressed: () {}),
                    ),
                  );
                },
                child: const Text('显示带 Action 的 SnackBar'),
              ),
            ),
            buildSchemeSection(
              title: 'surfaceTint',
              swatchColor: colorScheme.surfaceTint,
              subtitle: 'Elevation surface tint（Material 默认）',
              colorScheme: colorScheme,
              child: const Card(
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('elevation 较高时可见 surfaceTint'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ColorScheme 属性分组区块
  Widget buildSchemeSection({
    required String title,
    required String subtitle,
    required Color swatchColor,
    required ColorScheme colorScheme,
    required Widget child,
  }) {
    final isDark = colorScheme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: swatchColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: isDark ? colorScheme.surfaceContainerHigh : colorScheme.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
