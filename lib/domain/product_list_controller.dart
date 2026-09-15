import 'dart:async';
import 'package:flutter/foundation.dart' hide Category;
import '../data/models/product.dart';
import '../data/models/category.dart';
import '../data/repositories/product_repository.dart';
import '../data/exceptions/api_exception.dart';
import 'view_state.dart';

class ProductListController extends ChangeNotifier {
  final ProductRepository _repository;
  static const _pageLimit = 20;

  ProductListController(this._repository);

  List<Product> _products = [];
  ViewStatus _status = ViewStatus.initial;
  String _errorMessage = '';
  int _skip = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  String _searchQuery = '';
  String? _selectedCategory;
  List<Category> _categories = [];
  Timer? _debounce;

  List<Product> get products => _products;
  ViewStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get isLoadingMore => _isLoadingMore;
  String? get selectedCategory => _selectedCategory;
  List<Category> get categories => _categories;

  Future<void> loadCategories() async {
    try {
      _categories = await _repository.getCategories();
      notifyListeners();
    } catch (_) {
      // Category chips are a secondary feature; if this call fails,
      // the product list itself should still work normally.
    }
  }

  Future<void> loadInitial() async {
    _status = ViewStatus.loading;
    _skip = 0;
    _hasMore = true;
    notifyListeners();

    try {
      final results = await _fetchPage(skip: 0);

      _products = results;
      _skip = results.length;
      _hasMore = _searchQuery.isEmpty && results.length == _pageLimit;
      _status = results.isEmpty ? ViewStatus.empty : ViewStatus.success;
    } on ApiException catch (e) {
      _status = ViewStatus.error;
      _errorMessage = e.message;
    } catch (_) {
      _status = ViewStatus.error;
      _errorMessage = 'Something went wrong. Please try again.';
    }
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _searchQuery.isNotEmpty) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final results = await _fetchPage(skip: _skip);
      _products = [..._products, ...results];
      _skip += results.length;
      _hasMore = results.length == _pageLimit;
    } catch (_) {
      // Keep the current list visible; a failed "load more" shouldn't
      // wipe out products the user is already looking at.
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<List<Product>> _fetchPage({required int skip}) {
    if (_searchQuery.isNotEmpty) {
      return _repository.searchProducts(_searchQuery);
    }
    if (_selectedCategory != null) {
      return _repository.getProductsByCategory(
        category: _selectedCategory!,
        limit: _pageLimit,
        skip: skip,
      );
    }
    return _repository.getProducts(limit: _pageLimit, skip: skip);
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = query.trim();
      _selectedCategory = null;
      loadInitial();
    });
  }

  void filterByCategory(String? categorySlug) {
    _searchQuery = '';
    _selectedCategory = categorySlug;
    loadInitial();
  }

  void retry() => loadInitial();

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}