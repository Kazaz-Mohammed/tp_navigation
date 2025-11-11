import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_page.dart';
import 'favorites_page.dart';
import 'home_page.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/products_provider.dart';
import 'providers/stock_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProxyProvider<ProductsProvider, StockProvider>(
          create: (_) => StockProvider(),
          update: (_, productsProvider, stockProvider) {
            stockProvider ??= StockProvider();
            stockProvider.updateProducts(productsProvider.products);
            return stockProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Catalogue de produits',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          CartPage.routeName: (context) => const CartPage(),
          FavoritesPage.routeName: (context) => const FavoritesPage(),
        },
      ),
    );
  }
}
