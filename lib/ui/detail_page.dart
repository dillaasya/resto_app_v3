import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:resto_app_v3/api/api_service.dart';
import 'package:resto_app_v3/model/restaurant_detail.dart';
import 'package:resto_app_v3/model/restaurant.dart';
import 'package:resto_app_v3/provider/database_provider.dart';
import 'package:resto_app_v3/provider/detail_provider.dart';
import 'package:resto_app_v3/ui/add_review_page.dart';
import 'package:resto_app_v3/utils/result_state.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.restaurant,
  });

  static const routeName = '/detail_page';
  final Restaurant restaurant;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late CustomerReview review;

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController message = TextEditingController();

    void showBottomSheet() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (builder) {
            return AddNewReview(
                name: name, message: message, id: widget.restaurant.id, mounted: mounted, restaurant: widget.restaurant,);
          });
    }

    return ChangeNotifierProvider<DetailProvider>(
      create: (_) => DetailProvider(apiService: ApiService(), id: widget.restaurant.id),
      child: Consumer<DetailProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.hasData) {
            final detail = state.result.restaurantDetailsData;

            return Consumer<DatabaseProvider>(
              builder: (context, provider, child) {
                return FutureBuilder<bool>(
                  future: provider.isFavorite(detail.id),
                  builder: (context, snapshot) {
                    var isBookmarked = snapshot.data ?? false;

                    return Scaffold(
                      body: SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Stack(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 20),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Hero(
                                        tag: "image-resto${widget.restaurant.id}",
                                        child: Image.network(
                                          'https://restaurant-api.dicoding.dev/images/medium/${detail.pictureId}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 28,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                      child: isBookmarked
                                          ? IconButton(
                                              icon: const Icon(Icons.favorite),
                                              color: Colors.red,
                                              onPressed: () =>
                                                  provider.removeFavorite(widget.restaurant.id),
                                            )
                                          : IconButton(
                                              icon: const Icon(
                                                  Icons.favorite_border),
                                              color: const Color(0xFFaeaeae),
                                              onPressed: () =>
                                                  provider.addFavorite(widget.restaurant),
                                            ),
                                    ),
                                  )
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          detail.name,
                                          style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_rounded,
                                              color: Color(0xffE23E3E),
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              detail.city,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.star_rate_rounded,
                                              color: Colors.amber,
                                              size: 18,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(detail.rating.toString(),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20),
                                child: ReadMoreText(
                                  detail.description,
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                  trimLines: 5,
                                  colorClickableText: const Color(0xffE23E3E),
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Show more',
                                  trimExpandedText: 'Show less',
                                  moreStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ExpansionTile(
                                title: Text('Food Menu',
                                    style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                children: detail.menus.foods
                                    .map<Widget>((e) => buildMenuItem(e.name),)
                                    .toList(),
                              ),
                              ExpansionTile(
                                title: Text(
                                  'Drink Menu',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: detail.menus.drinks
                                    .map<Widget>((e) => buildMenuItem(e.name),)
                                    .toList(),
                              ),
                              ExpansionTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Reviews',
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "(${detail.customerReviews.length})",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200),
                                    )
                                  ],
                                ),
                                children: detail.customerReviews
                                    .map<Widget>(buildReviews)
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      floatingActionButton: FloatingActionButton(
                        tooltip: 'Add Review',
                        onPressed: showBottomSheet,
                        child: const Icon(
                          Icons.rate_review_rounded,
                          color: Colors.redAccent,
                        ),
                      ),
                    );
                  },
                );
              },
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

  Widget buildMenuItem(
    String name
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12, left: 16),
              child: Image.asset(
                "assets/Icon - Sushi.png",
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(name,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget buildReviews(CustomerReview e) {
    return ListTile(
      leading: const Icon(Icons.person_rounded),
      title: Text(e.name),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(e.review),
          const SizedBox(
            height: 10,
          ),
          Text(e.date)
        ],
      ),
    );
  }
}
