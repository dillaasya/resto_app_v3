import 'dart:convert';

RestaurantReview restaurantReviewFromJson(String str) =>
    RestaurantReview.fromJson(json.decode(str));

String restaurantReviewToJson(RestaurantReview data) =>
    json.encode(data.toJson());

class RestaurantReview {
  RestaurantReview({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  bool error;
  String message;
  List<CustomerReviews> customerReviews;

  factory RestaurantReview.fromJson(Map<String, dynamic> json) =>
      RestaurantReview(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReviews>.from(
            json["customerReviews"].map((x) => CustomerReviews.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "customerReviews":
    List<dynamic>.from(customerReviews.map((x) => x.toJson())),
  };
}

class CustomerReviews {
  CustomerReviews({
    required this.name,
    required this.id,
    required this.review,
    required this.date,
  });

  String name;
  String id;
  String review;
  String date;

  factory CustomerReviews.fromJson(Map<String, dynamic> json) => CustomerReviews(
    name: json["name"],
    id: json["id"],
    review: json["review"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id" : id,
    "name": name,
    "review": review,
    "date": date,
  };
}
