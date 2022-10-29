// To parse this JSON data, do
//
//     final restaurantDetails = restaurantDetailsFromJson(jsonString);

class RestaurantDetails {
  RestaurantDetails({
    required this.error,
    required this.message,
    required this.restaurantDetailsData,
  });

  bool error;
  String message;
  RestaurantDetailsData restaurantDetailsData;

  factory RestaurantDetails.fromJson(Map<String, dynamic> json) =>
      RestaurantDetails(
        error: json["error"],
        message: json["message"],
        restaurantDetailsData:
            RestaurantDetailsData.fromJson(json["restaurant"]),
      );
}

class RestaurantDetailsData {
  RestaurantDetailsData({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  List<Category> categories;
  Menus menus;
  String rating;
  List<CustomerReview> customerReviews;

  factory RestaurantDetailsData.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailsData(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        city: json["city"],
        address: json["address"],
        pictureId: json["pictureId"],
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
        menus: Menus.fromJson(json["menus"]),
        rating: json["rating"].toString(),
        customerReviews: List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "city": city,
        "address": address,
        "pictureId": pictureId,
        "rating": rating,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "menus": menus.toJson(),
        "customerReviews":
            List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    required this.name,
  });

  String name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class CustomerReview {
  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  String name;
  String review;
  String date;

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
        name: json["name"],
        review: json["review"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "review": review,
        "date": date,
      };
}

class Menus {
  Menus({
    required this.foods,
    required this.drinks,
  });

  List<FoodsDrinks> foods;
  List<FoodsDrinks> drinks;

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods: List<FoodsDrinks>.from(
            json["foods"].map((x) => FoodsDrinks.fromJson(x))),
        drinks: List<FoodsDrinks>.from(
            json["drinks"].map((x) => FoodsDrinks.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
      };
}

class FoodsDrinks {
  FoodsDrinks({
    required this.name,
  });

  String name;

  factory FoodsDrinks.fromJson(Map<String, dynamic> json) => FoodsDrinks(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
