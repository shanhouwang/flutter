import 'package:flutter/material.dart';
import '../utils/android_bridge.dart';
import '../viewmodels/product_list_viewmodel.dart';
import '../viewmodels/viewmodel_provider.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late ProductListViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = ProductListViewModel();
    _viewModel.initialize();
    
    // 监听搜索框变化
    _searchController.addListener(() {
      _viewModel.searchProducts(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  /// 下拉刷新
  Future<void> _onRefresh() async {
    await _viewModel.refresh();
  }

  /// 清除搜索
  void _clearSearch() {
    _searchController.clear();
    _viewModel.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      productListViewModel: _viewModel,
      child: ViewModelBuilder<ProductListViewModel>(
        viewModel: _viewModel,
        builder: (context, viewModel) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('商品列表'),
              backgroundColor: Colors.purple.shade100,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => AndroidBridge.goBack(),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '搜索商品...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: _buildBody(viewModel),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () => AndroidBridge.goBack(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('返回 Android'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 构建主体内容
  Widget _buildBody(ProductListViewModel viewModel) {
    if (viewModel.isLoading) {
      return _buildLoadingState();
    } else if (viewModel.hasError) {
      return _buildErrorState(viewModel);
    } else if (viewModel.isEmpty) {
      return _buildEmptyState();
    } else {
      return _buildProductList(viewModel);
    }
  }

  /// 加载状态
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('正在加载商品...'),
        ],
      ),
    );
  }

  /// 错误状态
  Widget _buildErrorState(ProductListViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            viewModel.error!,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: viewModel.retry,
            icon: const Icon(Icons.refresh),
            label: const Text('重试'),
          ),
        ],
      ),
    );
  }

  /// 空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '没有找到相关商品',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _clearSearch,
            icon: const Icon(Icons.clear_all),
            label: const Text('清除搜索'),
          ),
        ],
      ),
    );
  }

  /// 商品列表
  Widget _buildProductList(ProductListViewModel viewModel) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.filteredProducts.length,
      itemBuilder: (context, index) {
        final product = viewModel.filteredProducts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple.shade100,
              child: Icon(
                product.icon,
                color: Colors.purple,
              ),
            ),
            title: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.price,
                  style: TextStyle(
                    color: Colors.red[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (product.description != null)
                  Text(
                    product.description!,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/details',
                arguments: product,
              );
            },
          ),
        );
      },
    );
  }
}