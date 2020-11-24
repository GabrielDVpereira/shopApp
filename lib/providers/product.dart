import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    final _baseUrl = "${Constants.BASE_API_URL}/products";

    isFavorite = !isFavorite;
    notifyListeners();

    final reponse = await http.patch(
      "$_baseUrl/$id.json",
      body: json.encode(
        {"isFavorite": isFavorite},
      ),
    );

    if (reponse.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Ocorreu um erro.');
    }
  }
}
