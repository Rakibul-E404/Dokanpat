import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import 'api_service.dart';

final productProvider = FutureProvider<List<Product>>((ref) async {
  return ApiService().fetchProducts();
});
