import 'package:flutter_test/flutter_test.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/models/product_catalog_model.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/models/product_model.dart';

void main() {
  final tJson = {
    'products': [
      {
        'id': 1,
        'title': 'Essence Mascara Lash Princess',
        'description': 'The Essence Mascara Lash Princess',
        'category': 'beauty',
        'price': 9.99,
        'rating': 4.94,
        'discountPercentage': 7.17,
        'brand': 'Essence',
        'images': ['https://cdn.dummyjson.com/products/images/1.webp'],
      },
    ],
    'total': 194,
    'skip': 0,
    'limit': 10,
  };

  group('ProductCatalogModel', () {
    group('fromJson', () {
      test('crea el modelo correctamente desde un JSON válido', () {
        final result = ProductCatalogModel.fromJson(tJson);

        expect(result.total, equals(194));
        expect(result.skip, equals(0));
        expect(result.limit, equals(10));
        expect(result.products, isA<List<ProductModel>>());
        expect(result.products.length, equals(1));
      });

      test('mapea correctamente cada producto de la lista', () {
        final result = ProductCatalogModel.fromJson(tJson);
        final product = result.products.first;

        expect(product.id, equals(1));
        expect(product.title, equals('Essence Mascara Lash Princess'));
        expect(product.brand, equals('Essence'));
      });
    });

    group('toJson', () {
      test('convierte el modelo a JSON correctamente', () {
        final result = ProductCatalogModel.fromJson(tJson).toJson();

        expect(result['products'], isA<List>());
        expect((result['products'] as List).length, equals(1));
      });

      test('fromJson y toJson son consistentes en products', () {
        final model = ProductCatalogModel.fromJson(tJson);
        final result = model.toJson();
        final firstProduct =
            (result['products'] as List).first as Map<String, dynamic>;
        final originalProduct =
            (tJson['products'] as List).first as Map<String, dynamic>;

        expect(firstProduct['id'], equals(originalProduct['id']));
        expect(firstProduct['title'], equals(originalProduct['title']));
      });
    });
  });
}
