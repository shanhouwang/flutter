import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

/// 商品列表页面的 ViewModel
/// 负责管理商品数据、搜索逻辑和加载状态
class ProductListViewModel extends ChangeNotifier {
  // 私有状态变量
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;
  String _searchKeyword = '';

  // 公开的 getter 方法
  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchKeyword => _searchKeyword;
  bool get hasError => _error != null;
  bool get isEmpty => _filteredProducts.isEmpty && !_isLoading && !hasError;

  /// 初始化数据加载
  Future<void> initialize() async {
    await loadProducts();
  }

  /// 加载商品数据
  Future<void> loadProducts() async {
    _setLoading(true);
    _clearError();

    try {
      final products = await ApiService.getProducts();
      _products = products;
      _applySearch(); // 应用当前搜索条件
      _setLoading(false);
    } on ApiException catch (e) {
      _setError(e.message);
      _setLoading(false);
    } catch (e) {
      _setError('加载失败: ${e.toString()}');
      _setLoading(false);
    }
  }

  /// 搜索商品
  void searchProducts(String keyword) {
    _searchKeyword = keyword;
    _applySearch();
  }

  /// 清除搜索
  void clearSearch() {
    _searchKeyword = '';
    _applySearch();
  }

  /// 刷新数据
  Future<void> refresh() async {
    await loadProducts();
  }

  /// 重试加载
  Future<void> retry() async {
    await loadProducts();
  }

  // 私有辅助方法
  void _applySearch() {
    if (_searchKeyword.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      final keyword = _searchKeyword.toLowerCase();
      _filteredProducts = _products.where((product) =>
        product.name.toLowerCase().contains(keyword) ||
        (product.description?.toLowerCase().contains(keyword) ?? false)
      ).toList();
    }
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}