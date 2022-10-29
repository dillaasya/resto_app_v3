import 'package:http/http.dart' as http;
import 'package:resto_app_v3/model/restaurant.dart';
import 'package:resto_app_v3/model/restaurant_detail.dart';
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _main = 'list';
  static const String _detail = 'detail/';
  static const String _review = 'review';
  static const String _search = 'search?q=';

  Future<RestaurantList> restaurantList() async {
    final response = await http.get(Uri.parse(_baseUrl + _main));
    if (response.statusCode == 200) {
      return RestaurantList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<bool> postReview(String id, String name, String review) async {
    bool status = false;

    final response = await http.post(
      Uri.parse(_baseUrl + _review),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'id': id, 'name': name, 'review': review}),
    );

    if (response.statusCode == 201) {
      status = response.body.isNotEmpty;
    } else if (response.statusCode == 400) {
      throw response.statusCode.toString();
    } else if (response.statusCode == 500) {
      throw Exception("terjadi kesalahan pada server kami");
    }

    return status;
  }

  Future<RestaurantDetails> detailList(String? id) async {
    final response = await http.get(Uri.parse(_baseUrl + _detail + id!));
    if (response.statusCode == 200) {
      return RestaurantDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant details');
    }
  }

  Future<RestaurantResult> searchList(String query) async {
    final response = await http.get(Uri.parse(_baseUrl + _search + query));
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant search');
    }
  }
}
