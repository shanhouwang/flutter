import 'package:flutter/material.dart';

class Product {
  final String name;
  final String price;
  final IconData icon;

  const Product({
    required this.name,
    required this.price,
    required this.icon,
  });

  // 转换为 Map，用于传递参数
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'image': icon, // 保持与原代码兼容
    };
  }
}