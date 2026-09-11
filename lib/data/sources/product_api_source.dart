import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../exceptions/api_exception.dart';

// Access the dummy data sources 
class ProductApiDataSource { 
  static const _baseUrl = 'https://dummyjson.com';

  Future<List<Product>> fetchProducts({ 
    required int limit,
    required int skip,
  }) async { 
    final uri = Uri.parse('$_baseUrl/products?limit=$limit&skip=$skip');
    return _getProductList(uri);
  }

  Future<List<Product>> searchProducts(String query) async {
    final uri = Uri.parse('$_baseUrl/products/search?q=${Uri.encodeQueryComponent(query)}');
    return _getProductList(uri);
  }

  Future<Product> fetchProductById(int id) async { 
    final uri = Uri.parse('$_baseUrl/products/$id');
    
    try { 
      final response = await http.get(uri);
      
      if (response.statusCode == 200) { 
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Product.fromJson(json);
      }
      throw ApiException('Failed to load product with id $id (status: ${response.statusCode})');
    
    } on ApiException { 
      rethrow;

    } on FormatException { 
      throw ApiException('Received invalid data from server');

    } catch(_) { 
      throw ApiException('Network error: could not reach server');
    }
  }

  Future<List<Product>> _getProductList(Uri uri) async { 
    try { 
      final response = await http.get(uri);

      if (response.statusCode == 200) { 
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final list = json['products'] as List<dynamic>? ?? [];
        return list
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw ApiException('Failed to load products (status: ${response.statusCode})');

    } on ApiException { 
      rethrow;

    } on FormatException { 
      throw ApiException('Received invalid data from server');

    } catch(_) { 
      throw ApiException('Network error: could not reach server');
    }
  }
}