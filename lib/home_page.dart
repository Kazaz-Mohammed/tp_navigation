import 'package:flutter/material.dart';
import 'details_page.dart';
import 'models/product.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Product> products = [
    Product(
      name: 'Laptop HP',
      price: 9000,
      description: 'Ordinateur portable 16Go RAM',
    ),
    Product(
      name: 'iPhone 15',
      price: 15000,
      description: 'Smartphone dernière génération',
    ),
    Product(
      name: 'Casque JBL',
      price: 800,
      description: 'Casque sans fil Bluetooth',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue de produits'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('${product.price} MAD'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

