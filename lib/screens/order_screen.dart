import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/order.dart';
import '../widgets/order_item.dart' as ordItem;

class OrderScreen extends StatelessWidget {
  static const routeName = "/order";
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      body: ListView.builder(
        itemCount: orderData.order.length,
        itemBuilder: (ctx, index) {
          return ordItem.OrderItem(orderData.order[index]);
        },
      ),
    );
  }
}
