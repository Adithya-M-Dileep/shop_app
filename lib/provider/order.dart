import 'package:flutter/material.dart';
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
  List<OrderItem> _orders = [];

  List<OrderItem> get order {
    return [..._orders];
  }

  void addOrders(List<CartItem> products, double amount) {
    _orders.insert(
        0,
        OrderItem(
          id: DateTime.now().toString(),
          amount: amount,
          products: products,
          datetime: DateTime.now(),
        ));

    ChangeNotifier();
  }
}
