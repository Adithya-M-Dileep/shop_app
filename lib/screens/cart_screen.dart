import "package:flutter/material.dart";
import "package:provider/provider.dart";

import '../provider/cart.dart';
import '../widgets/cart_item.dart' as ci;
import '../provider/order.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart-screen";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Cart",
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      "\$${cart.totalAmount().toStringAsFixed(2)}",
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Provider.of<Order>(context, listen: false).addOrders(
                        cart.items.values.toList(),
                        cart.totalAmount(),
                      );

                      cart.clearCart();
                    },
                    child: Text(
                      "Order Now",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount(),
              itemBuilder: ((context, index) => ci.CartItem(
                    cart.items.keys.toList()[index],
                    cart.items.values.toList()[index].id,
                    cart.items.values.toList()[index].title,
                    cart.items.values.toList()[index].price,
                    cart.items.values.toList()[index].quantity,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
