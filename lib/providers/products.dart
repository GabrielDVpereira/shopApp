import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import '../models/product.dart';

// ChangeNotifier notifica mudancas pra quem consumir esse provider
class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items =>
      [..._items]; // retornando a cópia, não a referencia de items

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
