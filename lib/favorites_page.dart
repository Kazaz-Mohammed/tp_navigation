import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'details_page.dart';
import 'models/product.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/products_provider.dart';
import 'providers/stock_provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  static const routeName = '/favorites';

  void _addToCart(BuildContext context, Product product) {
    final stockProvider = context.read<StockProvider>();
    final success = stockProvider.decrement(product);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock insuffisant')),
      );
      return;
    }
    context.read<CartProvider>().addProduct(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} ajouté au panier')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final products = context.watch<ProductsProvider>().products;
    final stockProvider = context.watch<StockProvider>();

    final favorites = products
        .where((product) => favoritesProvider.isFavorite(product))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              tooltip: 'Vider les favoris',
              onPressed: favoritesProvider.clear,
              icon: const Icon(Icons.delete_sweep),
            ),
        ],
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('Aucun produit en favori'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];
                final stock = stockProvider.stockFor(product);

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
                              icon: const Icon(Icons.favorite),
                              color: Colors.redAccent,
                              tooltip: 'Retirer des favoris',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${product.price.toStringAsFixed(2)} MAD',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text('Stock disponible : $stock'),
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
                                    builder: (_) =>
                                        DetailsPage(product: product),
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

