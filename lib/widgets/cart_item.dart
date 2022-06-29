import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(this.productId, this.id, this.title, this.price, this.quantity);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 35,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(2),
                child: FittedBox(child: Text("\$$price")),
              ),
            ),
            title: Text(title),
            subtitle: Text(
              "Total: \$${price * quantity}",
            ),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
