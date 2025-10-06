import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String price;
  final IconData icon;
  final String? description;  // 新增描述字段
  final String? imageUrl;     // 新增图片URL字段
  final String? category;     // 新增分类字段

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.icon,
    this.description,
    this.imageUrl,
    this.category,
  });

  // 从 JSON 创建 Product 对象
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as String,
      icon: _getIconFromCategory(json['category'] as String?),
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String?,
    );
  }

  // 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  // 转换为 Map，用于传递参数（保持向后兼容）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': icon, // 保持与原代码兼容
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  // 根据分类返回对应图标
  static IconData _getIconFromCategory(String? category) {
    switch (category?.toLowerCase()) {
      case 'phone':
        return Icons.phone_iphone;
      case 'laptop':
        return Icons.laptop_mac;
      case 'tablet':
        return Icons.tablet_mac;
      case 'watch':
        return Icons.watch;
      case 'headphone':
        return Icons.headphones;
      case 'camera':
        return Icons.camera_alt;
      default:
        return Icons.shopping_bag;
    }
  }
}