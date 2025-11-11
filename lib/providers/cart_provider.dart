import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList(growable: false);

  int get totalItems =>
      _items.values.fold(0, (total, item) => total + item.quantity);

  double get totalPrice => _items.values.fold(
        0,
        (total, item) => total + item.quantity * item.product.price,
      );

  void addProduct(Product product) {
    final existing = _items[product.id];
    if (existing != null) {
      existing.quantity += 1;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeOne(Product product) {
    final existing = _items[product.id];
    if (existing == null) return;

    if (existing.quantity > 1) {
      existing.quantity -= 1;
    } else {
      _items.remove(product.id);
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    if (_items.remove(product.id) != null) {
      notifyListeners();
    }
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}

