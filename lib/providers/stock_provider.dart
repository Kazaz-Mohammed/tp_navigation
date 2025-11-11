import 'package:flutter/material.dart';

import '../models/product.dart';

class StockProvider with ChangeNotifier {
  List<Product> _products = const [];

  void updateProducts(List<Product> products) {
    _products = products;
  }

  int stockFor(Product product) => product.stock;

  int stockForId(String productId) {
    try {
      return _products
          .firstWhere((product) => product.id == productId)
          .stock;
    } catch (_) {
      return 0;
    }
  }

  bool decrement(Product product) {
    if (product.stock <= 0) {
      return false;
    }
    product.stock -= 1;
    notifyListeners();
    return true;
  }

  void increment(Product product) {
    product.stock += 1;
    notifyListeners();
  }

  void incrementBy(Product product, int value) {
    if (value <= 0) return;
    product.stock += value;
    notifyListeners();
  }

  void setStock(Product product, int value) {
    product.stock = value < 0 ? 0 : value;
    notifyListeners();
  }
}

