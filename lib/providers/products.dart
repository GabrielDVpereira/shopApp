import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/dummy_data.dart';
import 'product.dart';

// ChangeNotifier notifica mudancas pra quem consumir esse provider
class Products with ChangeNotifier {
  final _url = "https://flutter-cod3r-d235e.firebaseio.com/products.json";

  List<Product> _items = [];

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

  Future<void> loadProducts() async {
    final response = await http.get(_url);
    Map<String, dynamic> data = json.decode(response.body);

    _items.clear();
    if (data != null) {
      data.forEach(
        (productFirebaseId, productData) {
          _items.add(
            Product(
              id: productFirebaseId,
              title: productData["title"],
              description: productData["description"],
              price: productData["price"],
              imageUrl: productData["imageUrl"],
              isFavorite: productData["isFavorite"],
            ),
          );
        },
      );
    }
    notifyListeners();
    return Future.value();
  }

  Future<void> addProduct(Product product) async {
    try {
      var response = await http.post(
        _url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite
        }),
      );

      _items.add(
        Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
        ),
      );
      notifyListeners();

      return response;
    } catch (error) {
      throw error;
    }
  }

  void updateProduct(Product product) {
    if (product == null || product.id == null) {
      return;
    }
    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);

    if (index >= 0) {
      _items.removeWhere((product) => product.id == id);
      notifyListeners();
    }
  }
}
