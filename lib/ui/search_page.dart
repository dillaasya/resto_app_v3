import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app_v3/api/api_service.dart';
import 'package:resto_app_v3/model/restaurant.dart';
import 'package:resto_app_v3/provider/search_provider.dart';
import 'package:resto_app_v3/provider/theme_provider.dart';
import 'package:resto_app_v3/utils/result_state.dart';
import 'package:resto_app_v3/widget/restosearch_card_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  static const routeName = '/search_page';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  TextEditingController? querySearch = TextEditingController();
  late final List<Restaurant> restaurant;

  @override
  dispose() {
    querySearch!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context, listen: true);

    return ChangeNotifierProvider<SearchProvider>(
      create: (_) => SearchProvider(apiService: ApiService(), query: query),
      child: Consumer<SearchProvider>(builder: (context, state, _) {
        return Scaffold(
            body: SafeArea(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        style: TextStyle(
                          color: theme.getTheme() == theme.lightTheme
                              ? Colors.grey.shade400
                              : Colors.grey.shade800,
                        ),
                        controller: querySearch,
                        onSubmitted: (searchQuery) {
                          setState(() {
                            state.fetchRestaurantSearch(searchQuery);
                            _buildSearch(context, state);
                          });
                        },
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.search,
                            color: theme.getTheme() == theme.lightTheme
                                ? Colors.grey.shade400
                                : Colors.grey.shade800,
                          ),
                          hintText: "Type restaurant name here...",
                          hintStyle: TextStyle(
                            color: theme.getTheme() == theme.lightTheme
                                ? Colors.grey.shade400
                                : Colors.grey.shade800,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      querySearch!.clear();
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: Color(0xffE23E3E),
                    ),
                  ),
                ],
              ),
            ),
            querySearch!.text.isNotEmpty
                ? _buildSearch(context, state)
                : Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: const <Widget>[
                        Text('There\'s nothing to show'),
                      ],
                    ),
                  ),
          ],
        )));
      }),
    );
  }
}

Widget _buildSearch(BuildContext context, SearchProvider state) {
  if (state.state == ResultState.loading) {
    return const Center(child: CircularProgressIndicator());
  } else if (state.state == ResultState.hasData) {
    return Expanded(
      child: ListView.builder(
        itemCount: state.result.restaurants.length,
        padding: const EdgeInsets.only(left: 20, right: 20),
        itemBuilder: (context, index) {
          var restaurant = state.result.restaurants[index];

          return RestoSearchCard(restaurant: restaurant);
        },
      ),
    );
  } else if (state.state == ResultState.noData) {
    return Center(child: Text(state.message));
  } else if (state.state == ResultState.error) {
    return Center(child: Text(state.message));
  } else {
    return const Center(child: Text(''));
  }
}
