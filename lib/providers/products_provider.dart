import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: 'hp-laptop',
      name: 'Laptop HP',
      price: 9000,
      description: 'Ordinateur portable 16Go RAM',
      stock: 5,
    ),
    Product(
      id: 'iphone-15',
      name: 'iPhone 15',
      price: 15000,
      description: 'Smartphone dernière génération',
      stock: 8,
    ),
    Product(
      id: 'jbl-headset',
      name: 'Casque JBL',
      price: 800,
      description: 'Casque sans fil Bluetooth',
      stock: 12,
    ),
  ];

  List<Product> get products => List.unmodifiable(_products);

  Product? findById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (_) {
      return null;
    }
  }
}

