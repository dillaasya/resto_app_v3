import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resto_app_v3/api/api_service.dart';
import 'package:resto_app_v3/model/restaurant.dart';
import 'package:resto_app_v3/provider/list_provider.dart';

import 'json_parsing_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  var parsingTest = {
    "id": "rqdv5juczeskfw1e867",
    "name": "Melting Pot",
    "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
    "pictureId": "14",
    "city": "Medan",
    "rating": 4.2
  };

  String jsonResponse = '''
  {
    "error": false,
    "message": "success",
    "count": 20,
    "restaurants": [
        {
            "id": "rqdv5juczeskfw1e867",
            "name": "Melting Pot",
            "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
            "pictureId": "14",
            "city": "Medan",
            "rating": 4.2
        },
        {
            "id": "s1knt6za9kkfw1e867",
            "name": "Kafe Kita",
            "description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
            "pictureId": "25",
            "city": "Gorontalo",
            "rating": 4
        }
    ]
}
  ''';
  final client = MockClient();

  test('model test', () {
    // The model should be able to receive the following data:
    final user = Restaurant(
      id: '',
      name: '',
      description: '',
      pictureId: '',
      city: '',
      rating: '',
    );

    expect(user.id, '');
    expect(user.name, '');
    expect(user.description, '');
    expect(user.pictureId, '');
    expect(user.city, '');
    expect(user.rating, '');
  });

  test('list parsing', () async {

    when(client
        .get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
        .thenAnswer((_) async =>
        http.Response(jsonResponse, 200));
    ListProvider restaurantProvider =
    ListProvider(apiService: ApiService(client: client));
    await restaurantProvider.fetchRestaurantList();
    //act
    var resultRestaurantId = restaurantProvider.result.restaurants[0].id ==
        Restaurant.fromJson(parsingTest).id;
    var resultRestaurantName = restaurantProvider.result.restaurants[0].name ==
        Restaurant.fromJson(parsingTest).name;
    // assert
    expect(resultRestaurantId, true);
    expect(resultRestaurantName, true);
  });
}


