import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/product.dart';

/// JSON simülasyonu: ürünler internetten değil, assets klasöründeki
/// products.json dosyasından okunur.
class ProductRepository {
  static Future<List<Product>> loadProducts() async {
    final jsonString = await rootBundle.loadString('assets/data/products.json');
    final List<dynamic> list = jsonDecode(jsonString) as List<dynamic>;
    return list
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
