import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import "../screens/order_screen.dart";
import '../screens/user_products_screen.dart';
import '../provider/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text("Hello Friend!"),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text("Shop"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed("/");
          },
        ),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text("Order"),
          onTap: () {
            Navigator.of(context).pushNamed(OrderScreen.routeName);
          },
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("Manage Products"),
          onTap: () {
            Navigator.of(context).pushNamed(UserProductsScreen.routeName);
          },
        ),
        ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logOut();
            }),
      ]),
    );
  }
}
