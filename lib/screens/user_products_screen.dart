import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../provider/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_Product_item.dart';
import '../screens/edit_productScreen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products";
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: productData.item.length,
        itemBuilder: (_, i) {
          return Column(
            children: [
              UserProductItem(
                productData.item[i].id,
                productData.item[i].title,
                productData.item[i].imageUrl,
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
