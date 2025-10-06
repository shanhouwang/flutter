import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

/// 商品列表页面的 ViewModel
/// 负责管理商品数据、搜索逻辑和加载状态
class ProductListViewModel extends ChangeNotifier {
  // 私有状态变量
  List<Product> _products = [];
  List<Product> _filteredAll = []; // 搜索后完整集合
  List<Product> _filteredProducts = []; // 当前分页可见集合
  bool _isLoading = false;
  String? _error;
  String _searchKeyword = '';

  // 前端分页控制
  final int _pageSize = 20;
  int _visibleCount = 0;
  bool _isLoadingMore = false;

  // 公开的 getter 方法
  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  String get searchKeyword => _searchKeyword;
  bool get hasError => _error != null;
  bool get isEmpty => _filteredProducts.isEmpty && !_isLoading && !hasError;
  bool get hasMore => _visibleCount < _filteredAll.length;

  /// 初始化数据加载
  Future<void> initialize() async {
    await loadProducts();
  }

  /// 加载商品数据（首次或刷新）
  Future<void> loadProducts() async {
    _setLoading(true);
    _clearError();

    try {
      final products = await ApiService.getProducts();
      _products = products;
      // 重置搜索与分页
      _visibleCount = 0;
      _applySearch(resetPagination: true); // 应用当前搜索条件并重置分页
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
    _applySearch(resetPagination: true);
  }

  /// 清除搜索
  void clearSearch() {
    _searchKeyword = '';
    _applySearch(resetPagination: true);
  }

  /// 刷新数据
  Future<void> refresh() async {
    await loadProducts();
  }

  /// 重试加载
  Future<void> retry() async {
    await loadProducts();
  }

  /// 加载更多（前端分页）
  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore || _isLoading) return;
    _isLoadingMore = true;
    notifyListeners();

    // 模拟分页加载（真实场景应调用分页 API）
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final nextVisible = (_visibleCount + _pageSize).clamp(0, _filteredAll.length);
    _visibleCount = nextVisible;
    _rebuildVisible();
    _isLoadingMore = false;
    notifyListeners();
  }

  // 私有辅助方法
  void _applySearch({bool resetPagination = false}) {
    // 计算搜索后的完整集合
    if (_searchKeyword.isEmpty) {
      _filteredAll = List<Product>.from(_products);
    } else {
      final keyword = _searchKeyword.toLowerCase();
      _filteredAll = _products.where((product) =>
        product.name.toLowerCase().contains(keyword) ||
        (product.description?.toLowerCase().contains(keyword) ?? false)
      ).toList();
    }

    if (resetPagination) {
      _visibleCount = _filteredAll.isEmpty ? 0 : _pageSize.clamp(0, _filteredAll.length);
    }
    _rebuildVisible();
    notifyListeners();
  }

  void _rebuildVisible() {
    _filteredProducts = _filteredAll.take(_visibleCount).toList();
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

}