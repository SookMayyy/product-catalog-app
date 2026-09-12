import 'package:flutter/foundation.dart';
import '../data/models/product.dart';
import '../data/repositories/product_repository.dart';
import '../data/exceptions/api_exception.dart';
import 'view_state.dart';

class ProductDetailController extends ChangeNotifier {
  final ProductRepository _repository;
  final int productId;

  ProductDetailController(this._repository, this.productId);

  ViewStatus _status = ViewStatus.initial;
  String _errorMessage = '';
  Product? _product;

  ViewStatus get status => _status;
  String get errorMessage => _errorMessage;
  Product? get product => _product;

  Future<void> loadProduct() async {
    _status = ViewStatus.loading;
    notifyListeners();

    try {
      _product = await _repository.getProductById(productId);
      _status = ViewStatus.success;

    } on ApiException catch (e) {
      _status = ViewStatus.error;
      _errorMessage = e.message;

    } catch (_) {
      _status = ViewStatus.error;
      _errorMessage = 'Something went wrong. Please try again.';
    }
    
    notifyListeners();
  }

  void retry() => loadProduct();
}