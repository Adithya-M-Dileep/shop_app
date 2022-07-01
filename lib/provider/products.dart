import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exceptions.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _item = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get item {
    return [..._item];
  }

  List<Product> get favItems {
    return _item.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _item.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        "https://shop-app-d7add-default-rtdb.firebaseio.com/products.json");

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedProducts = [];
      if (extractedData == null) return;
      extractedData.forEach((key, prod) {
        loadedProducts.add(
          Product(
            id: key,
            title: prod["title"],
            description: prod["description"],
            price: prod["price"],
            imageUrl: prod["imageUrl"],
            isFavorite: prod["isFavorite"],
          ),
        );
      });
      _item = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) {
    final url = Uri.parse(
        "https://shop-app-d7add-default-rtdb.firebaseio.com/products.json");

    return http
        .post(
      url,
      body: json.encode({
        "title": product.title,
        "description": product.description,
        "imageUrl": product.imageUrl,
        "price": product.price,
        "isFavorite": product.isFavorite,
      }),
    )
        .then((response) {
      final _newProduct = Product(
        id: json.decode(response.body)["name"],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _item.add(_newProduct);
      notifyListeners();
    }).catchError((error) => throw error);
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final prodIndex = _item.indexWhere((prod) => prod.id == updatedProduct.id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          "https://shop-app-d7add-default-rtdb.firebaseio.com/products/${updatedProduct.id}.json");
      await http.patch(url,
          body: json.encode({
            "title": updatedProduct.title,
            "description": updatedProduct.description,
            "imageUrl": updatedProduct.imageUrl,
            "price": updatedProduct.price,
            "isFavorite": updatedProduct.isFavorite,
          }));
      _item[prodIndex] = updatedProduct;
      notifyListeners();
    }
  }

  Future<void> removeProduct(String id) async {
    final url = Uri.parse(
        "https://shop-app-d7add-default-rtdb.firebaseio.com/products/$id.json");
    final existingPeoductIndex =
        _item.indexWhere((element) => element.id == id);
    var existingProduct = _item[existingPeoductIndex];
    _item.removeAt(existingPeoductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _item.insert(existingPeoductIndex, existingProduct);
      notifyListeners();
      throw HttpExceptions("Could not delete product");
    }
    existingProduct = null;
  }
}
