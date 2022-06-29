import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../provider/products.dart';

class ProductGrid extends StatelessWidget {
  bool _showFav;
  ProductGrid(this._showFav);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = _showFav ? productData.favItems : productData.item;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
    );
  }
}
