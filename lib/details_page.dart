import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/product.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/stock_provider.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.product});

  final Product product;

  void _addToCart(BuildContext context) {
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

  void _decrementStock(BuildContext context) {
    final success = context.read<StockProvider>().decrement(product);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock déjà à zéro')),
      );
    }
  }

  void _incrementStock(BuildContext context) {
    context.read<StockProvider>().increment(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Stock de ${product.name} augmenté')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stock = context.watch<StockProvider>().stockFor(product);
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isFavorite = favoritesProvider.isFavorite(product);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            onPressed: () => favoritesProvider.toggleFavorite(product),
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.redAccent : null,
            ),
            tooltip:
                isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              'Prix : ${product.price.toStringAsFixed(2)} MAD',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Stock :'),
                const SizedBox(width: 12),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _decrementStock(context),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  '$stock',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _incrementStock(context),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: stock > 0 ? () => _addToCart(context) : null,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Ajouter au panier'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}

