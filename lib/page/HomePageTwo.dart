import 'package:color_scheme_demo/util/AppThemeService.dart';
import 'package:flutter/material.dart';

import '../widget/drawer_left.dart';
import '../widget/seed_color_box.dart';

class HomePageTwo extends StatefulWidget {
  const HomePageTwo({super.key});

  @override
  State<HomePageTwo> createState() => _HomePageTwoState();
}

class _HomePageTwoState extends State<HomePageTwo> with SingleTickerProviderStateMixin, SeedColorMixin {
  int _selectedIndex = 0;
  bool _isChecked = true;
  bool _isSwitched = true;
  double _sliderValue = 50;
  double _rangeStart = 20;
  double _rangeEnd = 80;
  int _radioValue = 1;
  int _selectedChip = 0;
  String _selectedOption = '选项1';
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final TextEditingController _textController = TextEditingController();
  bool _isExpanded = false;
  bool _showBanner = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  bool _isSearching = false;
  String _searchQuery = '';
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
      ),
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('Material 3 完整组件集'),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.color_lens,
                  color: colorScheme.primary,
                ),
                onPressed: showSeedColorPicker,
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
            bottom: _isSearching
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SearchBar(
                        hintText: '搜索...',
                        onChanged: (value) => setState(() => _searchQuery = value),
                      ),
                    ),
                  )
                : const TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.widgets), text: '基础'),
                      Tab(icon: Icon(Icons.layers), text: '布局'),
                      Tab(icon: Icon(Icons.navigation), text: '导航'),
                      Tab(icon: Icon(Icons.input), text: '输入'),
                      Tab(icon: Icon(Icons.extension), text: '高级'),
                    ],
                  ),
          ),
          body: TabBarView(
            children: [
              _buildBasicComponents(),
              _buildLayoutComponents(),
              _buildNavigationComponents(),
              _buildInputComponents(),
              _buildAdvancedComponents(),
            ],
          ),
          drawer: DrawerLeft(),
          endDrawer: _buildEndDrawer(),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: '首页'),
              NavigationDestination(icon: Icon(Icons.search), label: '搜索'),
              NavigationDestination(icon: Icon(Icons.favorite), label: '收藏'),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          // persistentFooterButtons: [
          //   TextButton(onPressed: () {}, child: const Text('帮助')),
          //   TextButton(onPressed: () {}, child: const Text('反馈')),
          // ],
        ),
      ),
    );
  }

  Widget _buildBasicComponents() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('按钮系列 (Buttons)'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            ElevatedButton(onPressed: () {}, child: const Text('ElevatedButton')),
            FilledButton(onPressed: () {}, child: const Text('FilledButton')),
            FilledButton.tonal(onPressed: () {}, child: const Text('FilledButton.tonal')),
            OutlinedButton(onPressed: () {}, child: const Text('OutlinedButton')),
            TextButton(onPressed: () {}, child: const Text('TextButton')),
            IconButton(onPressed: () {}, icon: const Icon(Icons.star)),
            IconButton.filled(onPressed: () {}, icon: const Icon(Icons.star)),
            IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.star)),
            IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.star)),
            FloatingActionButton.small(onPressed: () {}, child: const Icon(Icons.add)),
            FloatingActionButton.large(onPressed: () {}, child: const Icon(Icons.add)),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('选项1')),
                ButtonSegment(value: 2, label: Text('选项2')),
                ButtonSegment(value: 3, label: Text('选项3')),
              ],
              selected: const {1},
              onSelectionChanged: (selected) {},
            ),
          ]),

          _buildSectionTitle('卡片系列 (Cards)'),
          Card(child: ListTile(title: const Text('Card'), subtitle: const Text('标准卡片'))),
          const SizedBox(height: 8),
          // ElevatedCard(child: ListTile(title: const Text('ElevatedCard'), subtitle: const Text(' elevated卡片'))),
          // const SizedBox(height: 8),
          // FilledCard(child: ListTile(title: const Text('FilledCard'), subtitle: const Text('填充卡片'))),
          // const SizedBox(height: 8),
          // OutlinedCard(child: ListTile(title: const Text('OutlinedCard'), subtitle: const Text('轮廓卡片'))),

          _buildSectionTitle('芯片系列 (Chips)'),
          Wrap(spacing: 8, children: [
            InputChip(label: const Text('InputChip'), onPressed: () {}),
            FilterChip(label: const Text('FilterChip'), selected: _selectedChip == 0, onSelected: (_) {}),
            ActionChip(label: const Text('ActionChip'), onPressed: () {}),
            ChoiceChip(label: const Text('ChoiceChip'), selected: _selectedChip == 1, onSelected: (_) {}),
            // AssistChip(label: const Text('AssistChip'), onPressed: () {}),
          ]),

          _buildSectionTitle('进度指示器 (Progress)'),
          LinearProgressIndicator(value: _sliderValue / 100),
          const SizedBox(height: 8),
          CircularProgressIndicator(value: _sliderValue / 100),
          const SizedBox(height: 8),
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: Container(height: 100, color: Colors.grey.shade100, child: const Center(child: Text('下拉刷新'))),
          ),

          _buildSectionTitle('对话框系列 (Dialogs)'),
          Wrap(spacing: 8, children: [
            FilledButton(onPressed: _showAlertDialog, child: const Text('AlertDialog')),
            FilledButton(onPressed: _showSimpleDialog, child: const Text('SimpleDialog')),
            FilledButton(onPressed: _showModalBottomSheet, child: const Text('BottomSheet')),
          ]),
        ],
      ),
    );
  }

  Widget _buildLayoutComponents() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('布局容器 (Containers)'),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Container'),
          ),
          _buildSectionTitle('约束容器 (ConstrainedBox)'),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200, minHeight: 50),
            child: Container(color: Colors.green.shade100, child: const Center(child: Text('ConstrainedBox'))),
          ),
          _buildSectionTitle('装饰容器 (DecoratedBox)'),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.purple.shade100, Colors.pink.shade100]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('DecoratedBox'),
            ),
          ),
          _buildSectionTitle('变换容器 (Transform)'),
          Transform.rotate(
            angle: 0.1,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.red.shade100,
              child: const Text('Transform.rotate'),
            ),
          ),
          const SizedBox(height: 16),
          Transform.scale(
            scale: 0.8,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade100,
              child: const Text('Transform.scale'),
            ),
          ),
          _buildSectionTitle('流式布局 (Wrap & Flow)'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(10, (index) => Chip(label: Text('标签 $index'))),
          ),
          _buildSectionTitle('堆叠布局 (Stack)'),
          SizedBox(
            height: 100,
            child: Stack(
              children: [
                Container(color: Colors.blue.shade100, width: double.infinity),
                const Positioned(top: 20, left: 20, child: Text('Stack Item 1')),
                const Positioned(top: 40, left: 40, child: Text('Stack Item 2')),
              ],
            ),
          ),
          _buildSectionTitle('表格布局 (Table)'),
          Table(
            border: TableBorder.all(),
            children: const [
              TableRow(children: [
                TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('A1'))),
                TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('B1'))),
              ]),
              TableRow(children: [
                TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('A2'))),
                TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('B2'))),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationComponents() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('导航栏 (NavigationBar)'),
          NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: '首页'),
              NavigationDestination(icon: Icon(Icons.business), label: '商业'),
              NavigationDestination(icon: Icon(Icons.school), label: '学校'),
            ],
          ),
          _buildSectionTitle('导航轨道 (NavigationRail)'),
          SizedBox(
            height: 200,
            child: NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home), label: Text('首页')),
                NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('收藏')),
                NavigationRailDestination(icon: Icon(Icons.settings), label: Text('设置')),
              ],
            ),
          ),
          _buildSectionTitle('分页视图 (PageView)'),
          SizedBox(
            height: 200,
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: [
                Container(color: Colors.red.shade100, child: const Center(child: Text('页面 1'))),
                Container(color: Colors.green.shade100, child: const Center(child: Text('页面 2'))),
                Container(color: Colors.blue.shade100, child: const Center(child: Text('页面 3'))),
              ],
            ),
          ),
          _buildSectionTitle('底部导航栏 (BottomNavigationBar)'),
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: '搜索'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: '个人'),
            ],
          ),
          _buildSectionTitle('面包屑导航 (Breadcrumb)'),
          Wrap(
            children: [
              FilledButton.tonal(onPressed: () {}, child: const Text('首页')),
              const Icon(Icons.chevron_right),
              FilledButton.tonal(onPressed: () {}, child: const Text('分类')),
              const Icon(Icons.chevron_right),
              const Text('详情', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputComponents() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('文本输入 (Text Fields)'),
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'TextField',
              hintText: '请输入内容',
              prefixIcon: Icon(Icons.text_fields),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'TextFormField',
              hintText: '带验证的输入框',
            ),
            validator: (value) => value!.isEmpty ? '不能为空' : null,
          ),
          _buildSectionTitle('搜索框 (SearchBar)'),
          SearchBar(
            hintText: '搜索...',
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          _buildSectionTitle('选择控件 (Selections)'),
          Row(children: [
            Checkbox(value: _isChecked, onChanged: (v) => setState(() => _isChecked = v!)),
            const Text('Checkbox'),
            Switch(value: _isSwitched, onChanged: (v) => setState(() => _isSwitched = v)),
            const Text('Switch'),
          ]),
          Wrap(children: [
            Radio<int>(value: 1, groupValue: _radioValue, onChanged: (v) => setState(() => _radioValue = v!)),
            const Text('选项1'),
            Radio<int>(value: 2, groupValue: _radioValue, onChanged: (v) => setState(() => _radioValue = v!)),
            const Text('选项2'),
          ]),
          _buildSectionTitle('滑块控件 (Sliders)'),
          Slider(value: _sliderValue, max: 100, onChanged: (v) => setState(() => _sliderValue = v)),
          RangeSlider(
            values: RangeValues(_rangeStart, _rangeEnd),
            max: 100,
            onChanged: (values) => setState(() {
              _rangeStart = values.start;
              _rangeEnd = values.end;
            }),
          ),
          _buildSectionTitle('下拉选择 (Dropdowns)'),
          DropdownButton<String>(
            value: _selectedOption,
            items: const [
              DropdownMenuItem(value: '选项1', child: Text('选项1')),
              DropdownMenuItem(value: '选项2', child: Text('选项2')),
              DropdownMenuItem(value: '选项3', child: Text('选项3')),
            ],
            onChanged: (value) => setState(() => _selectedOption = value!),
          ),
          _buildSectionTitle('日期时间选择器'),
          Wrap(spacing: 8, children: [
            FilledButton(
              onPressed: _showDatePicker,
              child: const Text('日期选择'),
            ),
            FilledButton(
              onPressed: _showTimePicker,
              child: const Text('时间选择'),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildAdvancedComponents() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('数据表格 (DataTable)'),
          DataTable(
            columns: const [
              DataColumn(label: Text('姓名')),
              DataColumn(label: Text('年龄')),
              DataColumn(label: Text('城市')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('张三')),
                DataCell(Text('25')),
                DataCell(Text('北京')),
              ]),
              DataRow(cells: [
                DataCell(Text('李四')),
                DataCell(Text('30')),
                DataCell(Text('上海')),
              ]),
            ],
          ),
          _buildSectionTitle('可折叠面板 (ExpansionPanel)'),
          ExpansionPanelList(
            expansionCallback: (index, isExpanded) => setState(() => _isExpanded = !isExpanded),
            children: [
              ExpansionPanel(
                headerBuilder: (context, isExpanded) => const ListTile(title: Text('可折叠标题')),
                body: const ListTile(title: Text('可折叠内容')),
                isExpanded: _isExpanded,
              ),
            ],
          ),
          _buildSectionTitle('工具提示 (Tooltip)'),
          Tooltip(
            message: '这是一个Tooltip',
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.amber.shade100,
              child: const Text('悬停显示Tooltip'),
            ),
          ),
          _buildSectionTitle('横幅 (Banner)'),
          Banner(
            message: '横幅信息',
            location: BannerLocation.topStart,
            child: Container(
              height: 50,
              color: Colors.green.shade100,
              child: const Center(child: Text('Banner组件')),
            ),
          ),
          _buildSectionTitle('表单 (Form)'),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: '用户名'),
                  validator: (value) => value!.isEmpty ? '请输入用户名' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: '密码'),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? '请输入密码' : null,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('表单验证成功')),
                      );
                    }
                  },
                  child: const Text('提交'),
                ),
              ],
            ),
          ),
          _buildSectionTitle('动画容器 (AnimatedContainer)'),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isExpanded ? 200 : 100,
            height: _isExpanded ? 100 : 50,
            color: _isExpanded ? Colors.blue.shade100 : Colors.red.shade100,
            child: const Center(child: Text('AnimatedContainer')),
          ),
          FilledButton(
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            child: Text(_isExpanded ? '收缩' : '展开'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    // return _buildEndDrawer();
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        const DrawerHeader(decoration: BoxDecoration(color: Colors.blue), child: Text('Drawer Header')),
        ListTile(leading: const Icon(Icons.home), title: const Text('首页'), onTap: () {}),
        ListTile(leading: const Icon(Icons.settings), title: const Text('设置'), onTap: () {}),
        const Divider(),
        ListTile(leading: const Icon(Icons.info), title: const Text('关于'), onTap: () {}),
      ]),
    );
  }

  Widget _buildEndDrawer() {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        const UserAccountsDrawerHeader(
          accountName: Text('用户名'),
          accountEmail: Text('user@example.com'),
          currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
        ),
        ListTile(leading: const Icon(Icons.star), title: const Text('收藏'), onTap: () {}),
        ListTile(leading: const Icon(Icons.history), title: const Text('历史'), onTap: () {}),
      ]),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AlertDialog'),
        content: const Text('这是一个警告对话框'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('确定'))],
      ),
    );
  }

  void _showSimpleDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('SimpleDialog'),
        children: [
          SimpleDialogOption(onPressed: () => Navigator.pop(context), child: const Text('选项1')),
          SimpleDialogOption(onPressed: () => Navigator.pop(context), child: const Text('选项2')),
        ],
      ),
    );
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 200,
        child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Modal BottomSheet'),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('关闭')),
        ])),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }
}
