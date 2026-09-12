import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/product.dart';
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
  Timer? _debounce;

  List<Product> get products => _products;
  ViewStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadInitial() async {
    _status = ViewStatus.loading;
    _skip = 0;
    _hasMore = true;
    notifyListeners();

    try {
      final results = _searchQuery.isEmpty
          ? await _repository.getProducts(limit: _pageLimit, skip: 0)
          : await _repository.searchProducts(_searchQuery);

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
      final results =
          await _repository.getProducts(limit: _pageLimit, skip: _skip);
      _products = [..._products, ...results];
      _skip += results.length;
      _hasMore = results.length == _pageLimit;
    } catch (_) {
      // failed loading should not change the current state
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = query.trim();
      loadInitial();
    });
  }

  void retry() => loadInitial();

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}