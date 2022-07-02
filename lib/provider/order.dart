import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.datetime});
}

class Order with ChangeNotifier {
  final String authId;
  final String UserId;
  List<OrderItem> _orders = [];

  Order(this.authId, this.UserId, this._orders);

  List<OrderItem> get order {
    return [..._orders];
  }

  Future<void> addOrders(List<CartItem> products, double amount) async {
    final url = Uri.parse(
        "https://shop-app-d7add-default-rtdb.firebaseio.com/orders/$UserId.json?auth=$authId");

    final response = await http
        .post(
      url,
      body: json.encode({
        "amount": amount,
        "datetime": DateTime.now().toIso8601String(),
        "products": products
            .map((p) => {
                  "id": p.id,
                  "title": p.title,
                  "quantity": p.quantity,
                  "price": p.price,
                })
            .toList(),
      }),
    )
        .then((response) {
      _orders.insert(
          0,
          OrderItem(
            id: DateTime.now().toString(),
            amount: amount,
            products: products,
            datetime: DateTime.now(),
          ));

      notifyListeners();
    }).catchError((error) => throw error);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        "https://shop-app-d7add-default-rtdb.firebaseio.com/orders/$UserId.json?auth=$authId");

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<OrderItem> loadedProducts = [];
      if (extractedData == null) return;
      extractedData.forEach((key, ord) {
        loadedProducts.add(
          OrderItem(
              id: key,
              amount: ord["amount"],
              datetime: DateTime.parse(ord["datetime"]),
              products: (ord["products"] as List<dynamic>)
                  .map((item) => CartItem(
                        id: item["id"],
                        title: item["title"],
                        price: item["price"],
                        quantity: item["quantity"],
                      ))
                  .toList()),
        );
      });
      _orders = loadedProducts.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
