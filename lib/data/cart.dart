import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/mini_size.dart';
import '../models/product.dart';

/// Basit sepet simülasyonu.
/// Ekstra paket kullanmadan, Flutter'ın kendi ChangeNotifier sınıfıyla
/// state güncellemesi yapılır. Ekranlar ListenableBuilder ile dinler.
class Cart extends ChangeNotifier {
  Cart._();
  static final Cart instance = Cart._();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get count => _items.fold(0, (sum, item) => sum + item.quantity);

  double get total => _items.fold(0.0, (sum, item) => sum + item.total);

  bool get isEmpty => _items.isEmpty;

  void add(Product product, MiniSize size, {int quantity = 1}) {
    // Aynı ürün + aynı boyut varsa adedi artır.
    final index = _items.indexWhere(
      (i) => i.product.id == product.id && i.size == size,
    );
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, size: size, quantity: quantity));
    }
    notifyListeners();
  }

  void increase(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decrease(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
