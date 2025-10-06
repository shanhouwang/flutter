import 'package:flutter/material.dart';
import 'product_list_viewmodel.dart';

/// 简单的 ViewModel 提供者
/// 用于管理 ViewModel 的生命周期和依赖注入
class ViewModelProvider extends InheritedWidget {
  final ProductListViewModel productListViewModel;

  const ViewModelProvider({
    super.key,
    required this.productListViewModel,
    required super.child,
  });

  static ViewModelProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ViewModelProvider>();
  }

  static ProductListViewModel productListOf(BuildContext context) {
    final provider = of(context);
    assert(provider != null, 'ViewModelProvider not found in context');
    return provider!.productListViewModel;
  }

  @override
  bool updateShouldNotify(ViewModelProvider oldWidget) {
    return productListViewModel != oldWidget.productListViewModel;
  }
}

/// ViewModel 的 ChangeNotifier 监听器 Widget
class ViewModelBuilder<T extends ChangeNotifier> extends StatefulWidget {
  final T viewModel;
  final Widget Function(BuildContext context, T viewModel) builder;

  const ViewModelBuilder({
    super.key,
    required this.viewModel,
    required this.builder,
  });

  @override
  State<ViewModelBuilder<T>> createState() => _ViewModelBuilderState<T>();
}

class _ViewModelBuilderState<T extends ChangeNotifier> extends State<ViewModelBuilder<T>> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.viewModel);
  }
}