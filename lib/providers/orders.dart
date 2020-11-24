import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/cart.dart';
import 'package:shop/utils/constants.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({this.id, this.total, this.products, this.date});
}

class Orders with ChangeNotifier {
  final _baseUrl = "${Constants.BASE_API_URL}/orders";

  List<Order> _items = [];
  List<Order> loadedItems = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    final response = await http.get("$_baseUrl.json");
    Map<String, dynamic> data = json.decode(response.body);
    print(data);

    if (data != null) {
      data.forEach(
        (orderFirebaseId, orderData) {
          loadedItems.add(
            Order(
              id: orderFirebaseId,
              total: orderData['total'],
              date: DateTime.parse(orderData['date']),
              products: (orderData['products'] as List<dynamic>).map((item) {
                return CartItem(
                    id: item['id'],
                    price: item['price'],
                    productId: item['productId'],
                    quantity: item['quantity'],
                    title: item['title']);
              }).toList(),
            ),
          );
        },
      );
      notifyListeners();
    }
    _items = loadedItems.reversed.toList();
    return Future.value();
  }

  Future<void> addOrder(List<CartItem> productsOnCart, double total) async {
    final date = DateTime.now();

    final response = await http.post("$_baseUrl.json",
        body: json.encode({
          "total": total,
          "date": date.toIso8601String(),
          "products": productsOnCart
              .map((cartItem) => {
                    "id": cartItem.id,
                    "productId": cartItem.productId,
                    "title": cartItem.title,
                    "quantity": cartItem.quantity,
                    "price": cartItem.price
                  })
              .toList()
        }));

    _items.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        total: total,
        products: productsOnCart,
        date: date,
      ),
    );
    notifyListeners();
  }
}
