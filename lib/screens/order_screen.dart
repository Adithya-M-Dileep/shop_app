import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/order.dart';
import '../widgets/order_item.dart' as ordItem;

class OrderScreen extends StatefulWidget {
  static const routeName = "/order";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _orderFuture;

  Future _obtainOrderFuture() {
    return Provider.of<Order>(context, listen: false).fetchAndSetProducts();
  }

  @override
  void initState() {
    _orderFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Orders"),
        ),
        body: FutureBuilder(
          future: _orderFuture,
          builder: (ctx, daraSnapshot) {
            if (daraSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (daraSnapshot.error != null) {
              return Center(
                child: Text("error occured!"),
              );
            } else {
              return Consumer<Order>(
                  builder: (ctx, orderData, child) => ListView.builder(
                        itemCount: orderData.order.length,
                        itemBuilder: (ctx, index) {
                          return ordItem.OrderItem(orderData.order[index]);
                        },
                      ));
            }
          },
        ));
  }
}
