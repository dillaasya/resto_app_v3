import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resto_app_v3/model/restaurant.dart';
import 'package:resto_app_v3/model/restaurant_review.dart';
import 'package:resto_app_v3/provider/review_provider.dart';
import 'package:resto_app_v3/ui/detail_page.dart';

class AddNewReview extends StatelessWidget {
  const AddNewReview({
    Key? key,
    required this.name,
    required this.message,
    required this.id,
    required this.mounted,
    required this.restaurant,
  }) : super(key: key);

  final TextEditingController name;
  final TextEditingController message;
  final String id;
  final bool mounted;
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    Future<void> post() async {
      var provider = Provider.of<ReviewProvider>(context, listen: false);
      CustomerReviews customerReviews = CustomerReviews(
          name: name.text,
          id: id,
          review: message.text,
          date: DateTime.now().toString());

      await provider.postReview(customerReviews);
      if (provider.isback && mounted) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, DetailPage.routeName,
            arguments: id);
      } else if (provider.isback == false) {
        print('NAH LOH EROR, ID REVIEW : $id');
      } else {
        print('I DONT KNOW');
      }
    }

    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Add New Review',
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            controller: name,
            autofocus: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                label: Text(
                  'Name',
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.normal),
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: message,
            maxLines: 4,
            minLines: 2,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                label: Text(
                  'Review',
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.normal),
                )),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xffE23E3E),
                ),
                onPressed: (){
                  post();
                },
                child: Text('Add',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              )
            ],
          )
        ],
      ),
    ));
  }
}
