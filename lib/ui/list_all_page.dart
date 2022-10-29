import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resto_app_v3/api/api_service.dart';
import 'package:resto_app_v3/provider/list_provider.dart';
import 'package:resto_app_v3/provider/theme_provider.dart';
import 'package:resto_app_v3/ui/detail_page.dart';
import 'package:resto_app_v3/utils/result_state.dart';

class ListAllPage extends StatelessWidget {
  const ListAllPage({
    super.key,
  });

  static const routeName = '/list_page';
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context, listen: true);

    return ChangeNotifierProvider<ListProvider>(
      create: (_) => ListProvider(
        apiService: ApiService(),
      ),
      child: Consumer<ListProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.hasData) {
            return Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: state.result.restaurants.length,
                          itemBuilder: (context, index) {
                            var restaurant = state.result.restaurants[index];
                            return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return DetailPage(
                                          restaurant: restaurant,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.all(10),
                                  color: theme.getTheme() == theme.lightTheme
                                      ? Colors.grey.shade200
                                      : Colors.grey.shade800,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                          child: Image.network(
                                            'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4, left: 4),
                                        child: Text(
                                          maxLines: 1,
                                          restaurant.name,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, bottom: 4),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.location_on_rounded,
                                              color: Colors.red,
                                              size: 15,
                                            ),
                                            Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              restaurant.city,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w200,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (state.state == ResultState.noData) {
            return Center(child: Text(state.message));
          } else if (state.state == ResultState.error) {
            return Scaffold(body: Center(child: Text(state.message)));
          } else {
            return const Center(child: Text(''));
          }
        },
      ),
    );
  }
}
