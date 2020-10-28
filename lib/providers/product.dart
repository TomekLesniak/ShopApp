import 'dart:convert';

import 'package:ShopApp/models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite; //temporarly

  Product(
      { @required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});


  Future<void> toggleFavoriteStatus(String userId, String authToken) async{
    final url =
        'https://flutter-shop-educational.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';

    isFavorite = !isFavorite;
    final response = await http.put(url,
        body: json.encode(isFavorite));

    if(response.statusCode >= 400)
      throw HttpException('Could not fetch product');
    notifyListeners();
  }

  
}
