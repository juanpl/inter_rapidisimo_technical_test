import 'package:flutter_test/flutter_test.dart';
import 'package:inter_rapidisimo_technical_test/features/product_catalog/data/models/product_model.dart';

void main() {
  const tJson = {
    'id': 1,
    'title': 'Essence Mascara Lash Princess',
    'description': 'The Essence Mascara Lash Princess',
    'category': 'beauty',
    'price': 9.99,
    'rating': 4.94,
    'discountPercentage': 7.17,
    'brand': 'Essence',
    'images': [
      'https://cdn.dummyjson.com/products/images/1.webp',
      'https://cdn.dummyjson.com/products/images/2.webp',
    ],
  };

  final tModel = ProductModel(
    id: 1,
    title: 'Essence Mascara Lash Princess',
    description: 'The Essence Mascara Lash Princess',
    category: 'beauty',
    price: 9.99,
    raiting: 4.94,
    discountPercentage: 7.17,
    brand: 'Essence',
    images: [
      'https://cdn.dummyjson.com/products/images/1.webp',
      'https://cdn.dummyjson.com/products/images/2.webp',
    ],
  );

  group('ProductModel', () {
    group('fromJson', () {
      test('crea el modelo correctamente desde un JSON válido', () {
        final result = ProductModel.fromJson(tJson);

        expect(result.id, equals(1));
        expect(result.title, equals('Essence Mascara Lash Princess'));
        expect(result.description, equals('The Essence Mascara Lash Princess'));
        expect(result.category, equals('beauty'));
        expect(result.price, equals(9.99));
        expect(result.raiting, equals(4.94));
        expect(result.discountPercentage, equals(7.17));
        expect(result.brand, equals('Essence'));
        expect(result.images.length, equals(2));
      });

      test('images es una lista de Strings', () {
        final result = ProductModel.fromJson(tJson);

        expect(result.images, isA<List<String>>());
      });

      test('brand se mapea desde la clave brand del JSON', () {
        final result = ProductModel.fromJson(tJson);

        expect(result.brand, equals(tJson['brand']));
      });

      test('raiting se mapea desde la clave rating del JSON', () {
        final result = ProductModel.fromJson(tJson);

        expect(result.raiting, equals(tJson['rating']));
      });
    });

    group('toJson', () {
      test('convierte el modelo a JSON correctamente', () {
        final result = tModel.toJson();

        expect(result['id'], equals(1));
        expect(result['title'], equals('Essence Mascara Lash Princess'));
        expect(
          result['description'],
          equals('The Essence Mascara Lash Princess'),
        );
        expect(result['category'], equals('beauty'));
        expect(result['price'], equals(9.99));
        expect(result['raiting'], equals(4.94));
        expect(result['discountPercentage'], equals(7.17));
        expect(result['brand'], equals('Essence'));
        expect(result['images'], isA<List<String>>());
        expect(result['images'], equals(tModel.images));
      });

      test('fromJson y toJson son consistentes', () {
        final model = ProductModel.fromJson(tJson);
        final result = model.toJson();

        expect(result['id'], equals(tJson['id']));
        expect(result['title'], equals(tJson['title']));
        expect(result['brand'], equals(tJson['brand']));
        expect(result['images'], equals(tJson['images']));
      });
    });
  });
}
