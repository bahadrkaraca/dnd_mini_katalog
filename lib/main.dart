import 'package:flutter/material.dart';

import 'screens/cart_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() {
  runApp(const MiniKatalogApp());
}

class MiniKatalogApp extends StatelessWidget {
  const MiniKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zindan Atölyesi',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      // Named Routes
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        DetailScreen.routeName: (_) => const DetailScreen(),
        CartScreen.routeName: (_) => const CartScreen(),
      },
    );
  }
}
