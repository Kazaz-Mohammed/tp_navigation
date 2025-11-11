import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_page.dart';
import 'details_page.dart';
import 'favorites_page.dart';
import 'models/product.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/products_provider.dart';
import 'providers/stock_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _addToCart(BuildContext context, Product product) {
    final stockProvider = context.read<StockProvider>();
    final success = stockProvider.decrement(product);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit en rupture de stock')),
      );
      return;
    }

    context.read<CartProvider>().addProduct(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} ajouté au panier')),
    );
  }

  void _decrementStock(BuildContext context, Product product) {
    final success = context.read<StockProvider>().decrement(product);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock déjà à zéro')),
      );
    }
  }

  void _incrementStock(BuildContext context, Product product) {
    context.read<StockProvider>().increment(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Stock de ${product.name} augmenté')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsProvider>().products;
    final stockProvider = context.watch<StockProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue de produits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () =>
                Navigator.pushNamed(context, FavoritesPage.routeName),
          ),
          Consumer<CartProvider>(
            builder: (_, cart, child) => Badge(
              isLabelVisible: cart.totalItems > 0,
              label: Text(cart.totalItems.toString()),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.pushNamed(context, CartPage.routeName),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final stock = stockProvider.stockFor(product);
          final isFavorite = favoritesProvider.isFavorite(product);

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            favoritesProvider.toggleFavorite(product),
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color:
                              isFavorite ? Colors.redAccent : Colors.grey[600],
                        ),
                        tooltip: isFavorite
                            ? 'Retirer des favoris'
                            : 'Ajouter aux favoris',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${product.price.toStringAsFixed(2)} MAD',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Stock :'),
                      const SizedBox(width: 8),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => _decrementStock(context, product),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '$stock',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => _incrementStock(context, product),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: stock > 0
                            ? () => _addToCart(context, product)
                            : null,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Ajouter au panier'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailsPage(product: product),
                            ),
                          );
                        },
                        child: const Text('Détails'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

