import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/pages.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _initialRoute = '/';
  static const platform = MethodChannel('flutter_to_android');

  @override
  void initState() {
    super.initState();
    _setupMethodChannel();
  }

  void _setupMethodChannel() {
    platform.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'setInitialRoute':
          setState(() {
            _initialRoute = call.arguments as String? ?? '/';
          });
          // 导航到指定路由
          if (navigatorKey.currentState != null) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
              _initialRoute,
              (route) => false,
            );
          }
          break;
      }
    });
  }

  // 全局导航键
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 模块',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // 设置初始路由
      initialRoute: _initialRoute,
      // 定义路由表
      routes: {
        '/': (context) => const FlutterHomePage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/products': (context) => const ProductListPage(),
        '/details': (context) => const ProductDetailPage(),
      },
      // 处理未知路由
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const NotFoundPage(),
        );
      },
    );
  }
}