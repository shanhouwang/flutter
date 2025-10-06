# Flutter Module

一个集成到 Android 应用中的 Flutter 模块，提供多个功能页面和与原生 Android 的双向通信能力。

## 📋 项目概述

这是一个模块化的 Flutter 项目，可以作为 Android 应用的一部分运行。项目采用组件化架构，将不同功能拆分为独立的页面组件，便于维护和扩展。

## 🏗️ 项目结构

```
flutter_module/lib/
├── main.dart                    # 主入口文件，包含 MyApp 和路由配置
├── pages/                       # 页面组件目录
│   ├── pages.dart              # 页面统一导出文件
│   ├── flutter_home_page.dart  # 首页组件 (StatefulWidget)
│   ├── profile_page.dart       # 个人资料页面 (StatelessWidget)
│   ├── settings_page.dart      # 设置页面 (StatefulWidget)
│   ├── product_list_page.dart  # 商品列表页面 (StatelessWidget)
│   ├── product_detail_page.dart # 商品详情页面 (StatelessWidget)
│   └── not_found_page.dart     # 404 页面 (StatelessWidget)
├── models/                      # 数据模型目录
│   └── product.dart            # 商品数据模型
└── utils/                       # 工具类目录
    └── android_bridge.dart     # Android 通信桥接工具
```

## 🚀 功能特性

### 页面功能
- **首页** - 访问计数器、导航按钮、渐变背景
- **个人资料** - 用户信息展示（邮箱、电话、地址）
- **设置页面** - 推送通知开关、深色模式开关、语言设置
- **商品列表** - 展示商品列表，支持点击查看详情
- **商品详情** - 显示商品详细信息，支持添加到购物车
- **404页面** - 处理未知路由的友好错误页面

### 技术特性
- ✅ **组件化架构** - 每个页面独立组件，职责单一
- ✅ **状态管理** - 合理使用 StatefulWidget 和 StatelessWidget
- ✅ **路由管理** - 完整的路由配置和导航系统
- ✅ **原生通信** - 通过 MethodChannel 与 Android 双向通信
- ✅ **类型安全** - 使用强类型数据模型
- ✅ **错误处理** - 未知路由处理和友好错误页面
- ✅ **响应式设计** - 适配不同屏幕尺寸

## 🔧 Android 集成

### MethodChannel 通信

#### Flutter → Android
```dart
// 返回到 Android 页面
AndroidBridge.goBack();
```

#### Android → Flutter
```dart
// 设置初始路由
platform.invokeMethod('setInitialRoute', '/profile');
```

### 支持的路由
- `/` - 首页
- `/profile` - 个人资料
- `/settings` - 设置
- `/products` - 商品列表
- `/details` - 商品详情（需要传递商品参数）

## 📱 页面截图

### 首页特性
- 访问计数器功能
- 美观的渐变背景
- 导航按钮组
- 返回 Android 功能

### 设置页面特性
- 推送通知开关
- 深色模式切换
- 语言设置选项
- 版本信息显示

## 🏛️ 架构设计

### 组件分类

#### StatefulWidget（有状态组件）
- **FlutterHomePage** - 管理访问计数器状态
- **SettingsPage** - 管理开关状态（通知、深色模式）

#### StatelessWidget（无状态组件）
- **ProfilePage** - 静态用户信息展示
- **ProductListPage** - 商品列表展示
- **ProductDetailPage** - 商品详情展示
- **NotFoundPage** - 静态错误页面

### 设计原则
1. **单一职责** - 每个组件只负责一个功能
2. **状态最小化** - 能用 StatelessWidget 就不用 StatefulWidget
3. **代码复用** - 公共逻辑提取到工具类
4. **类型安全** - 使用强类型数据模型

## 🛠️ 开发指南

### 添加新页面
1. 在 `pages/` 目录下创建新的页面文件
2. 在 `pages/pages.dart` 中导出新页面
3. 在 `main.dart` 的路由表中添加路由配置

```dart
// 1. 创建新页面
class NewPage extends StatelessWidget {
  // 页面实现
}

// 2. 导出页面
export 'new_page.dart';

// 3. 添加路由
routes: {
  '/new': (context) => const NewPage(),
}
```

### 添加新数据模型
在 `models/` 目录下创建新的模型文件：

```dart
class NewModel {
  final String property;
  
  const NewModel({required this.property});
  
  Map<String, dynamic> toMap() {
    return {'property': property};
  }
}
```

### Android 通信
使用 `AndroidBridge` 工具类进行通信：

```dart
// 调用 Android 方法
AndroidBridge.goBack();

// 在 Android 端接收
platform.setMethodCallHandler((call) async {
  switch (call.method) {
    case 'goBack':
      // 处理返回逻辑
      break;
  }
});
```

## 🎨 UI 设计

### 主题配置
- 使用 Material Design 3
- 主色调：蓝色系
- 支持渐变背景
- 统一的卡片设计

### 颜色方案
- **首页**：蓝色渐变背景
- **个人资料**：绿色主题
- **设置**：橙色主题
- **商品**：紫色主题
- **详情**：靛蓝主题

## 📦 依赖项

```yaml
dependencies:
  flutter:
    sdk: flutter
  # 其他依赖项...
```

## 🚀 运行项目

### 开发环境要求
- Flutter SDK 3.0+
- Dart 2.17+
- Android Studio / VS Code
- Android SDK

### 运行命令
```bash
# 获取依赖
flutter pub get

# 运行项目 (需要在 Android 项目中集成)
flutter run
```

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📞 联系方式

如有问题或建议，请通过以下方式联系：

- 项目 Issues: [GitHub Issues](https://github.com/your-repo/issues)
- 邮箱: your-email@example.com

---

**注意**: 此 Flutter 模块需要集成到 Android 项目中才能正常运行。请确保 Android 端正确配置了 MethodChannel 通信。