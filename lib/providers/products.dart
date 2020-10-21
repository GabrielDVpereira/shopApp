import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'product.dart';

// ChangeNotifier notifica mudancas pra quem consumir esse provider
class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  bool _showFavoriteOnly = false;

  List<Product> get items {
    if (_showFavoriteOnly) {
      return _items.where((prod) => prod.isFavorite).toList();
    }
    return [..._items]; // retornando a cópia, não a referencia de items
  }

  showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
