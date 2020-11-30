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

  Future<void> toggleFavorite(String token, String userId) async {
    final _baseUrl = "${Constants.BASE_API_URL}/userFav";

    isFavorite = !isFavorite;
    notifyListeners();

    final reponse = await http.put(
      "$_baseUrl/$userId/$id.json?auth=$token",
      body: json.encode(
        isFavorite,
      ),
    );

    if (reponse.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Ocorreu um erro.');
    }
  }
}
