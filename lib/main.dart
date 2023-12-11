import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

final _logger = Logger();

// 路由配置
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/second',
      builder: (context, state) => const SecondPage(),
    ),
  ],
);

// dio配置
final dio = Dio();
void dioConfig() {
  dio.options.baseUrl = 'https://lishuxue.site';
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 10);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
        // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
        _logger.d('onRequest');
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
        _logger.d('onResponse');
        return handler.next(response);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
        _logger.d('onError');
        return handler.next(error);
      },
    ),
  );
}

// 全局状态 models
class MyModel extends ChangeNotifier {
  // 内部状态 _items
  final List<int> _items = [1, 2, 3];
  // 外部获取该状态，返回一个不可修改的
  get items => UnmodifiableListView(_items);

  // 内部状态 totalPrice
  get totalPrice => _items.length * 42;

  void add(int number) {
    _items.add(number);
    // 通知widget更新
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}

void main() {
  dioConfig();
  // 主方法启动app
  runApp(const MyApp());
}

// 主App是个无状态Widget
class MyApp extends StatelessWidget {
  // 构造函数，并且将参数传给父类构造
  const MyApp({super.key});

  // 覆写 build 方法
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyModel()),
      ],
      child: MaterialApp.router(
        title: 'My Flutter Demo',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Colors.deepPurple), // 定义颜色
          useMaterial3: true, // 启用Material 3
        ),
        routerConfig: _router, // 路由配置
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // 构造方法，并且调用父类构造并传参
  const MyHomePage({super.key});

  // 覆写 createState 方法
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 不需要显式写构造方法

  // 自定义状态
  int _counter = 0;
  final int _currentIndex = 0; // 当前页面的索引，设置导航栏的active

  // 自定义的修改状态的方法
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  void initState() {
    super.initState();
    _logger.d('initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logger.d('didChangeDependencies');
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _logger.d('didUpdateWidget');
  }

  @override
  void deactivate() {
    super.deactivate();
    _logger.d('deactivate');
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('dispose');
  }

  // 覆写 build 方法
  @override
  Widget build(BuildContext context) {
    _logger.d('build');
    return Scaffold(
      // 顶部栏
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Page'),
      ),
      // 侧边栏
      drawer: Drawer(
        child: ListView(children: [
          ListTile(
            title: const Text('侧边菜单，Home'),
            selected: _currentIndex == 0, // active 状态
            onTap: () {
              // 处理侧边栏点击事件
              Navigator.pop(context);
              context.go('/');
            },
          ),
          ListTile(
            title: const Text('侧边菜单，Second'),
            selected: _currentIndex == 1,
            onTap: () {
              // 处理侧边栏点击事件
              Navigator.pop(context);
              context.go('/second');
            },
          ),
        ]),
      ),
      // 内容部分
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 主轴居中
          crossAxisAlignment: CrossAxisAlignment.center, // 交叉轴居中
          children: [
            const Text('Home Page'),
            Text('$_counter'),
            ElevatedButton(
              onPressed: () {
                // 处理按钮按下事件
                _logger.d('button pressed');
                // 修改全局状态
                context.read<MyModel>().add(1);
              },
              child: const Text('更新全局状态'),
            ),
            Consumer<MyModel>(
                builder: (context, my, child) =>
                    Text('全局状态 Total price: ${my.totalPrice}')),
            ElevatedButton(
              onPressed: () {
                // 修改全局状态
                Provider.of<MyModel>(context, listen: false).removeAll();
              },
              child: const Text('清空全局状态'),
            ),
          ],
        ),
      ),
      // 底部导航栏
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // active 状态
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Second',
          ),
        ],
        onTap: (int index) {
          // 处理底部导航栏点击事件
          if (index == 0) {
            context.go('/');
          }
          if (index == 1) {
            context.go('/second');
          }
        },
      ),
      // 悬浮按钮
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // FloatingActionButton.extended是FloatingActionButton的一个扩展版本，它允许在浮动操作按钮上显示文本和图标，以提供更多的信息。
          FloatingActionButton.extended(
            onPressed: _incrementCounter,
            icon: const Icon(Icons.add),
            label: const Text('Increment'),
            // 当我们在一个页面种使用两个FloatingActionButton却不覆写它们的heroTag属性，它们会默认使用同一个标识，以致于冲突报错。
            heroTag: 'Increment',
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: _decrementCounter,
            icon: const Icon(Icons.remove),
            label: const Text('Decrement'),
            heroTag: 'DecrementR',
          )
        ],
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  // 覆写 createState 方法
  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final int _currentIndex = 1; // 当前页面的索引，设置导航栏的active
  String _text = '初始值，点击发送请求后会变化';
  int _number = 0;

  // 网络请求
  void _request() async {
    try {
      Response response = await dio.get('/blog-api/common/homeinfo');
      var result = response.data;
      String text = result['one']['text'];
      _logger.d(text);
      setState(() {
        _text = text;
      });
    } on DioException catch (e) {
      _logger.d(e.message);
    }
  }

  // 设置持久化数据
  Future<void> _setSharedPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    int number = (prefs.getInt('number') ?? 0) + 1;
    await prefs.setInt('number', number);
  }

  // 获取持久化数据
  Future<void> _getSharedPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    final int number = prefs.getInt('number') ?? 0;
    setState(() {
      _number = number;
    });
  }

  @override
  void initState() {
    super.initState();
    _getSharedPreferencesData();
  }

  // 覆写 build 方法
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 顶部栏
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Second Page'),
      ),
      // 侧边栏
      drawer: Drawer(
        child: ListView(children: [
          ListTile(
            title: const Text('侧边菜单，Home'),
            selected: _currentIndex == 0, // active状态
            onTap: () {
              // 处理侧边栏点击事件
              Navigator.pop(context);
              context.go('/');
            },
          ),
          ListTile(
            title: const Text('侧边菜单，Second'),
            selected: _currentIndex == 1,
            onTap: () {
              // 处理侧边栏点击事件
              Navigator.pop(context);
              context.go('/second');
            },
          ),
        ]),
      ),
      // 内容部分
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 主轴居中
          crossAxisAlignment: CrossAxisAlignment.center, // 交叉轴居中
          children: [
            const Text('Second Page'),
            Text(_text),
            ElevatedButton(
              onPressed: () {
                _request();
              },
              child: const Text('发送请求'),
            ),
            Text('上次存储的数据：$_number'),
            ElevatedButton(
              onPressed: () {
                _setSharedPreferencesData();
              },
              child: const Text('存储数据'),
            ),
            ElevatedButton(
              onPressed: () {
                _getSharedPreferencesData();
              },
              child: const Text('获取持久化的数据'),
            ),
            Consumer<MyModel>(
                builder: (context, my, child) =>
                    Text('全局状态 items: ${my.items.toString()}')),
            Consumer<MyModel>(
                builder: (context, my, child) =>
                    Text('全局状态 Total price: ${my.totalPrice}')),
          ],
        ),
      ),
      // 底部导航栏
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // active状态
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Second',
          ),
        ],
        onTap: (int index) {
          // 处理底部导航栏点击事件
          if (index == 0) {
            context.go('/');
          }
          if (index == 1) {
            context.go('/second');
          }
        },
      ),
    );
  }
}
