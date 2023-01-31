import 'package:flutter/foundation.dart';
import 'package:resto_app_v3/api/api_service.dart';
import 'package:resto_app_v3/model/restaurant_review.dart';

class ReviewProvider extends ChangeNotifier{
  final ApiService apiService;

  ReviewProvider({required this.apiService});

  bool loading = false;
  bool isback = false;

  Future<void> postReview(CustomerReviews review)async{
    loading = true;
    notifyListeners();

    final response = await apiService.postReview(review);
    if (response!.statusCode == 201) {
      isback = true;
    }else if(response.statusCode == 500){
      if (kDebugMode) {
        print('API : Internal server eror');
      }
    }else if(response.statusCode == 400) {
      if (kDebugMode) {
        print('API : Data kurang lengkap');
      }
    }else {
      if (kDebugMode) {
        print('API : OPSI TERAKHIR GATAU');
      }
    }

    loading = false;
    notifyListeners();
  }

}