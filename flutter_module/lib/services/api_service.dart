import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// API 服务类，处理所有网络请求
class ApiService {
  static const String baseUrl = 'https://api.example.com'; // 替换为实际的API地址
  static const Duration timeout = Duration(seconds: 10);

  /// 获取商品列表
  static Future<List<Product>> getProducts() async {
    try {
      // 模拟网络请求延迟
      await Future.delayed(const Duration(seconds: 2));
      
      // 模拟 API 响应数据
      final mockResponse = {
        'success': true,
        'data': [
          {
            'id': 1,
            'name': 'iPhone 15 Pro',
            'price': '¥8999',
            'category': 'phone',
            'description': '搭载 A17 Pro 芯片的强大 iPhone',
            'imageUrl': 'https://example.com/iphone15.jpg'
          },
          {
            'id': 2,
            'name': 'MacBook Pro M3',
            'price': '¥14999',
            'category': 'laptop',
            'description': '配备 M3 芯片的专业级笔记本电脑',
            'imageUrl': 'https://example.com/macbook.jpg'
          },
          {
            'id': 3,
            'name': 'iPad Air',
            'price': '¥4599',
            'category': 'tablet',
            'description': '轻薄强大的 iPad Air',
            'imageUrl': 'https://example.com/ipad.jpg'
          },
          {
            'id': 4,
            'name': 'Apple Watch Ultra',
            'price': '¥6299',
            'category': 'watch',
            'description': '专为极致体验而设计的 Apple Watch',
            'imageUrl': 'https://example.com/watch.jpg'
          },
          {
            'id': 5,
            'name': 'AirPods Pro',
            'price': '¥1899',
            'category': 'headphone',
            'description': '主动降噪无线耳机',
            'imageUrl': 'https://example.com/airpods.jpg'
          },
        ]
      };

      if (mockResponse['success'] == true) {
        final List<dynamic> productsJson = mockResponse['data'] as List<dynamic>;
        return productsJson.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ApiException('获取商品列表失败');
      }

      /* 实际网络请求代码示例：
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> productsJson = data['data'];
          return productsJson.map((json) => Product.fromJson(json)).toList();
        } else {
          throw ApiException(data['message'] ?? '获取商品列表失败');
        }
      } else {
        throw ApiException('网络请求失败: ${response.statusCode}');
      }
      */

    } on SocketException {
      throw ApiException('网络连接失败，请检查网络设置');
    } on FormatException {
      throw ApiException('数据格式错误');
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e');
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('未知错误: ${e.toString()}');
    }
  }

  /// 根据分类获取商品
  static Future<List<Product>> getProductsByCategory(String category) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final allProducts = await getProducts();
      return allProducts.where((product) => 
        product.category?.toLowerCase() == category.toLowerCase()
      ).toList();
    } catch (e) {
      throw const ApiException('获取分类商品失败');
    }
  }

  /// 搜索商品
  static Future<List<Product>> searchProducts(String keyword) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      final allProducts = await getProducts();
      return allProducts.where((product) => 
        product.name.toLowerCase().contains(keyword.toLowerCase()) ||
        (product.description?.toLowerCase().contains(keyword.toLowerCase()) ?? false)
      ).toList();
    } catch (e) {
      throw const ApiException('搜索商品失败');
    }
  }
}

/// 自定义 API 异常类
class ApiException implements Exception {
  final String message;
  
  const ApiException(this.message);
  
  @override
  String toString() => 'ApiException: $message';
}