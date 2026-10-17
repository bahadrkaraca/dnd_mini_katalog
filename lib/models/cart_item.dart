import 'mini_size.dart';
import 'product.dart';

class CartItem {
  final Product product;
  final MiniSize size;
  int quantity;

  CartItem({required this.product, required this.size, this.quantity = 1});

  double get unitPrice => product.priceFor(size);
  double get total => unitPrice * quantity;
}
