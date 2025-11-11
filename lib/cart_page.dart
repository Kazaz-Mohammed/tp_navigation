import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart_item.dart';
import 'providers/cart_provider.dart';
import 'providers/stock_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  static const routeName = '/cart';

  void _showOutOfStock(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Stock insuffisant pour ajouter ce produit')),
    );
  }

  void _clearCart(BuildContext context, List<CartItem> items) {
    if (items.isEmpty) return;
    final stockProvider = context.read<StockProvider>();
    for (final item in items) {
      stockProvider.incrementBy(item.product, item.quantity);
    }
    context.read<CartProvider>().clear();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              tooltip: 'Vider le panier',
              onPressed: () => _clearCart(context, List.of(items)),
              icon: const Icon(Icons.delete_sweep),
            ),
        ],
      ),
      body: items.isEmpty
          ? const Center(
              child: Text('Votre panier est vide'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                final product = item.product;
                final stock =
                    context.watch<StockProvider>().stockFor(item.product);

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Prix unitaire : ${product.price.toStringAsFixed(2)} MAD',
                        ),
                        const SizedBox(height: 8),
                        Text('Disponible : $stock'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (item.quantity == 0) return;
                                context
                                    .read<CartProvider>()
                                    .removeOne(product);
                                context.read<StockProvider>().increment(
                                      product,
                                    );
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text(
                              '${item.quantity}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            IconButton(
                              onPressed: () {
                                final success = context
                                    .read<StockProvider>()
                                    .decrement(product);
                                if (!success) {
                                  _showOutOfStock(context);
                                  return;
                                }
                                context.read<CartProvider>().addProduct(
                                      product,
                                    );
                              },
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                            const Spacer(),
                            IconButton(
                              tooltip: 'Retirer du panier',
                              onPressed: () {
                                context
                                    .read<StockProvider>()
                                    .incrementBy(product, item.quantity);
                                context.read<CartProvider>().removeProduct(
                                      product,
                                    );
                              },
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Total : ${cart.totalPrice.toStringAsFixed(2)} MAD',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            FilledButton(
              onPressed: items.isEmpty ? null : () {},
              child: const Text('Commander'),
            ),
          ],
        ),
      ),
    );
  }
}

