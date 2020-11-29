import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/utils/constants.dart';
import 'product.dart';

// ChangeNotifier notifica mudancas pra quem consumir esse provider
class Products with ChangeNotifier {
  final _baseUrl = "${Constants.BASE_API_URL}/products";

  List<Product> _items = [];
  final String _token;
  bool _showFavoriteOnly = false;

  Products(this._token, this._items);

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
    final response = await http.get("$_baseUrl.json?auth=$_token");
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
        "$_baseUrl.json",
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

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }
    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      await http.patch(
        "$_baseUrl/${product.id}.json",
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
      return Future.value();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete("$_baseUrl/$id.json");

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException("Ocorreu um erro na exclusão do produto.");
      }
    }
  }
}
