import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import "../widgets/product_grid.dart";
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../provider/cart.dart';
import './cart_screen.dart';

enum filterOption {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showFavoriteOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MY Shop"),
        actions: [
          PopupMenuButton(
            onSelected: (filterOption choice) {
              setState(() {
                if (choice == filterOption.Favorite) {
                  showFavoriteOnly = true;
                } else {
                  showFavoriteOnly = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favorite"),
                value: filterOption.Favorite,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: filterOption.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount().toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ProductGrid(showFavoriteOnly),
    );
  }
}
