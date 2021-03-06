import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void changeFav(bool newFav) {
    isFavorite = newFav;
    notifyListeners();
  }

  Future<void> toggleFavorite(String authId, String userId) async {
    bool oldChoice = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final url = Uri.parse(
          "https://shop-app-d7add-default-rtdb.firebaseio.com/userFavorite/$userId/$id.json?auth=$authId");
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));

      if (response.statusCode >= 400) {
        changeFav(oldChoice);
      }
    } catch (error) {
      changeFav(oldChoice);
    }
  }
}
