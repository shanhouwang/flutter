# MyFlutterApplication

一个展示 Android 原生应用集成 Flutter 模块的混合开发项目。

## 项目概述

这是一个混合开发应用，主要包含：
- **Android 原生主应用**：使用 Kotlin + Jetpack Compose 开发
- **Flutter 模块**：作为子模块集成到 Android 应用中

## 项目结构

```
MyFlutterApplication/
├── app/                          # Android 主应用
│   ├── src/main/
│   │   ├── java/com/shawn/flutter/
│   │   │   └── MainActivity.kt   # 主 Activity
│   │   ├── res/                  # Android 资源文件
│   │   └── AndroidManifest.xml   # Android 清单文件
│   └── build.gradle              # Android 应用构建配置
├── flutter_module/               # Flutter 模块
│   ├── lib/                      # Flutter 源代码
│   ├── test/                     # Flutter 测试
│   └── pubspec.yaml              # Flutter 依赖配置
├── build.gradle                  # 项目级构建配置
├── settings.gradle               # 项目设置和仓库配置
└── README.md                     # 项目说明文档
```

## 技术栈

### Android 原生部分
- **语言**: Kotlin
- **UI 框架**: Jetpack Compose
- **最小 SDK**: 24 (Android 7.0)
- **目标 SDK**: 36
- **编译 SDK**: 36

### Flutter 模块部分
- **框架**: Flutter
- **语言**: Dart
- **集成方式**: Flutter Module

## 功能特性

### Android 主应用功能
- ✅ 现代化 Material Design 3 界面
- ✅ 点击计数功能
- ✅ 跳转到 Flutter 页面
- ✅ Flutter 引擎预热优化
- ✅ Flutter 与 Android 双向通信

### Flutter 模块功能
- ✅ 独立的 Flutter 页面
- ✅ 与 Android 原生通信
- ✅ 返回 Android 主页面功能

## 开发环境要求

### 必需软件
- **Android Studio**: Arctic Fox 或更高版本
- **Flutter SDK**: 3.0 或更高版本
- **Dart SDK**: 2.17 或更高版本
- **JDK**: 11 或更高版本

### 环境配置
1. 安装 Flutter SDK
2. 配置 Flutter 环境变量
3. 运行 `flutter doctor` 检查环境
4. 确保 Android SDK 已正确安装

## 快速开始

### 1. 克隆项目
```bash
git clone <repository-url>
cd MyFlutterApplication
```

### 2. 配置 Flutter 模块
```bash
cd flutter_module
flutter pub get
cd ..
```

### 3. 构建 Flutter 模块
```bash
cd flutter_module
flutter build aar
cd ..
```

### 4. 在 Android Studio 中打开项目
- 打开 Android Studio
- 选择 "Open an existing project"
- 选择项目根目录

### 5. 运行应用
- 连接 Android 设备或启动模拟器
- 点击 "Run" 按钮或使用快捷键 `Shift + F10`

## 构建配置

### 仓库配置 (settings.gradle)
```gradle
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        
        // Flutter 模块仓库
        String storageUrl = System.env.FLUTTER_STORAGE_BASE_URL ?: "https://storage.googleapis.com"
        maven {
            url '/Users/shawn/AndroidStudioProjects/MyFlutterApplication/flutter_module/build/host/outputs/repo'
        }
        maven {
            url "$storageUrl/download.flutter.io"
        }
    }
}
```

### Flutter 依赖配置 (app/build.gradle)
```gradle
dependencies {
    // Flutter 模块依赖
    debugImplementation 'com.example.flutter_module:flutter_debug:1.0'
    profileImplementation 'com.example.flutter_module:flutter_profile:1.0'
    releaseImplementation 'com.example.flutter_module:flutter_release:1.0'
}
```

### 构建类型配置
```gradle
android {
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        profile {
            initWith debug
        }
    }
}
```

## 关键实现

### Flutter 引擎管理
```kotlin
private fun warmUpFlutterEngine() {
    val flutterEngine = FlutterEngine(this)
    flutterEngine.dartExecutor.executeDartEntrypoint(
        DartExecutor.DartEntrypoint.createDefault()
    )
    
    // 设置通信通道
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        .setMethodCallHandler { call, result ->
            when (call.method) {
                "goBack" -> {
                    finish()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    
    FlutterEngineCache.getInstance().put(FLUTTER_ENGINE_ID, flutterEngine)
}
```

### 启动 Flutter 页面
```kotlin
private fun navigateToFlutter() {
    startActivity(
        FlutterActivity
            .withCachedEngine(FLUTTER_ENGINE_ID)
            .build(this)
    )
}
```

## 常见问题

### Q: FlutterActivity 找不到？
**A**: 确保在 AndroidManifest.xml 中声明了 FlutterActivity：
```xml
<activity
    android:name="io.flutter.embedding.android.FlutterActivity"
    android:exported="false"
    android:launchMode="singleTop"
    android:theme="@style/LaunchTheme" />
```

### Q: 构建失败，找不到 Flutter 依赖？
**A**: 
1. 确保已运行 `flutter build aar`
2. 检查 settings.gradle 中的仓库配置
3. 清理并重新构建项目

### Q: Flutter 页面启动慢？
**A**: 项目已实现 Flutter 引擎预热，在应用启动时就初始化 Flutter 引擎，减少首次启动时间。

## 性能优化

### 1. Flutter 引擎预热
- 在 MainActivity 的 onCreate 中预热 Flutter 引擎
- 使用 FlutterEngineCache 缓存引擎实例

### 2. 构建优化
- 使用 profile 构建类型进行性能测试
- 启用 R8 代码压缩（release 版本）

### 3. 内存管理
- 在 onDestroy 中清理 Flutter 引擎缓存
- 合理管理 Activity 生命周期

## 开发指南

### 添加新的 Flutter 页面
1. 在 flutter_module/lib 中创建新的 Dart 文件
2. 在 Android 中通过 MethodChannel 或路由导航

### Android 与 Flutter 通信
```kotlin
// Android 调用 Flutter
methodChannel.invokeMethod("methodName", arguments)

// Flutter 调用 Android
MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    .setMethodCallHandler { call, result ->
        // 处理 Flutter 的调用
    }
```

## 版本信息

- **项目版本**: 1.0.0
- **最低 Android 版本**: 7.0 (API 24)
- **目标 Android 版本**: 14 (API 36)

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目。

## 联系方式

如有问题或建议，请通过以下方式联系：
- 提交 GitHub Issue
- 发送邮件至：[your-email@example.com]

---

**注意**: 这是一个演示项目，展示了 Android 原生应用与 Flutter 模块的集成方案。在生产环境中使用时，请根据具体需求进行相应的安全性和性能优化。