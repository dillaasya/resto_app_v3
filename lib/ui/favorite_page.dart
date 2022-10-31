import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app_v3/api/api_service.dart';
import 'package:resto_app_v3/provider/database_provider.dart';
import 'package:resto_app_v3/provider/list_provider.dart';
import 'package:resto_app_v3/utils/result_state.dart';
import 'package:resto_app_v3/widget/restofav_card_widget.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListProvider>(
        create: (_) => ListProvider(apiService: ApiService()),
        child: Consumer<ListProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.hasData) {
              return SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<DatabaseProvider>(
                          builder: (context, provider, child) {
                            if (provider.state == ResultState.hasData) {
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: provider.favorites.length,
                                  itemBuilder: (context, index) {
                                    var favRestaurant =
                                        provider.favorites[index];
                                    return RestoFavCard(favRestaurant);
                                  },
                                ),
                              );
                            } else {
                              return Column(
                                children: const [
                                  Text(
                                    'There\'s empty here, try to add some favorited restaurant',
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    )),
              );
            } else if (state.state == ResultState.noData) {
              return Center(child: Text(state.message));
            } else if (state.state == ResultState.error) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text(''));
            }
          },
        ));
  }
}
