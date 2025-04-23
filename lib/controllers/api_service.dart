import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        final products = data.map((item) => Product.fromJson(item)).toList();

        final box = await Hive.openBox('products');
        box.put('cached_products', data);

        return products.cast<Product>();
      } else {
        throw Exception('Failed to load');
      }
    } catch (_) {
      final box = await Hive.openBox('products');
      final cached = box.get('cached_products');
      if (cached != null) {
        return (cached as List).map((e) => Product.fromJson(e)).toList();
      }
      rethrow;
    }
  }
}
