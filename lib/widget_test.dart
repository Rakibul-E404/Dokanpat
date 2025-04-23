import 'package:flutter_test/flutter_test.dart';
import 'models/product.dart';

void main() {
  test('Product model should convert from JSON correctly', () {
    final json = {
      'id': 1,
      'title': 'Test Product',
      'price': 99.99,
      'description': 'A test product',
      'category': 'electronics',
      'image': 'https://example.com/image.png',
      'rating': {'rate': 4.5}
    };

    final product = Product.fromJson(json);

    expect(product.id, 1);
    expect(product.title, 'Test Product');
    expect(product.price, 99.99);
    expect(product.rating, 4.5);
  });
}
