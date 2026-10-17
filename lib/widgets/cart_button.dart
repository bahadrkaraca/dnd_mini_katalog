import 'package:flutter/material.dart';

import '../data/cart.dart';
import '../screens/cart_screen.dart';
import '../theme.dart';

/// Sepet sayısını rozet olarak gösteren AppBar butonu.
class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Cart.instance,
      builder: (context, _) {
        final count = Cart.instance.count;
        return IconButton(
          tooltip: 'Sepet',
          onPressed: () => Navigator.pushNamed(context, CartScreen.routeName),
          icon: Badge(
            isLabelVisible: count > 0,
            backgroundColor: AppColors.crimson,
            label: Text('$count'),
            child: const Icon(Icons.shopping_bag_outlined),
          ),
        );
      },
    );
  }
}
