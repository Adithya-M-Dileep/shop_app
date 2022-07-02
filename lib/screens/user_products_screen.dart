import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../provider/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_Product_item.dart';
import '../screens/edit_productScreen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products";

  Future<void> _refreshPage(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: _refreshPage(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Products>(
                    builder: (ctx, productData, _) => RefreshIndicator(
                      onRefresh: (() => _refreshPage(context)),
                      child: ListView.builder(
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
                    ),
                  ),
      ),
    );
  }
}
