import 'package:flutter_test/flutter_test.dart';
import 'package:resto_app_v3/api/api_service.dart';

void main() {
  test(
      'returns a boolean to define whether the addition of a comment was successful or not',
      () async {
    // arrange
    var id = "rqdv5juczeskfw1e867";
    var name = "Adilla";
    var review = "Menu bervariasi";
    // act
    Future<bool> addReviewTest() async {
      late bool status;
      status = await ApiService().postReview(id, name, review);

      return status;
    }

    bool result = await addReviewTest();
    // assert

    expect(result, true);
  });
}
