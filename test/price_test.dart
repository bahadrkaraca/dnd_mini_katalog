import 'package:flutter_test/flutter_test.dart';

import 'package:dnd_mini_katalog/models/mini_size.dart';
import 'package:dnd_mini_katalog/models/product.dart';

void main() {
  final dragon = Product.fromJson({
    'id': 8,
    'name': 'Kırmızı Ejderha',
    'category': 'Boss',
    'basePrice': 250,
    'image': 'assets/images/dragon.png',
    'sizes': ['L', 'H', 'G'],
  });

  test('boyuta göre fiyat hesaplanır', () {
    expect(dragon.priceFor(MiniSize.large), 550);
    expect(dragon.priceFor(MiniSize.huge), 1130);
    expect(dragon.priceFor(MiniSize.gargantuan), 2250);
  });

  test('başlangıç fiyatı en küçük boyuttur', () {
    expect(dragon.startingPrice, 550);
  });

  test('toJson -> fromJson aynı ürünü verir', () {
    final copy = Product.fromJson(dragon.toJson());
    expect(copy.name, dragon.name);
    expect(copy.sizes, dragon.sizes);
  });
}
