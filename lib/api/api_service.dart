import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Client;

import 'package:resto_app_v3/model/restaurant.dart';
import 'package:resto_app_v3/model/restaurant_detail.dart';
import 'dart:convert';

import 'package:resto_app_v3/model/restaurant_review.dart';

class ApiService {
  Client? client;

  ApiService({this.client}) {
    client ??= Client();
  }

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

  Future<http.Response?> postReview(CustomerReviews review) async {
    http.Response? response;

    try{
      response = await http.post(
        Uri.parse(_baseUrl + _review),
        headers: {"Content-Type": " application/json"},
        body: json.encode(review),

      );
    }catch(e){
      log(e.toString());
    }
    return response;
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
