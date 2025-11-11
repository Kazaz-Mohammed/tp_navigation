import 'package:flutter/material.dart';

import '../models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  bool isFavorite(Product product) => _favoriteIds.contains(product.id);

  void toggleFavorite(Product product) {
    if (_favoriteIds.contains(product.id)) {
      _favoriteIds.remove(product.id);
    } else {
      _favoriteIds.add(product.id);
    }
    notifyListeners();
  }

  void clear() {
    if (_favoriteIds.isEmpty) return;
    _favoriteIds.clear();
    notifyListeners();
  }
}

