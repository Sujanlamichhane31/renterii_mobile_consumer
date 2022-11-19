import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:renterii/Locale/locales.dart';

import '../../../Locale/locales.dart';

class Review {
  final String? title;
  final dynamic rating;
  final String date;
  final String? content;

  Review(this.title, this.rating, this.date, this.content);
}

class ReviewsScreen extends StatefulWidget {
  final String? shopName;
  final String? username;
  final dynamic ratingNumber;
  final dynamic ratings;
  final dynamic numberOfReviews;

  const ReviewsScreen({Key? key, required this.shopName, required this.username, required this.ratingNumber, required this.ratings, required this.numberOfReviews}) : super(key: key);
  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    final List<Review> listOfReviews = [
      // Review(
      //     appLocalization.name1, 4.0, '5 April, 20', appLocalization.content1),
      // Review(
      //     appLocalization.name2, 5.0, '23 Feb, 20', appLocalization.content2),
      // Review(
      //     appLocalization.name3, 4.0, '11 April, 20', appLocalization.content1),
      // Review(
      //     appLocalization.name4, 5.0, '23 Feb, 20', appLocalization.content2),
      // Review(
      //     appLocalization.name5, 4.0, '9 April, 20', appLocalization.content1),
      // Review(
      //     appLocalization.name2, 5.0, '23 Feb, 20', appLocalization.content2),
      // Review(
      //     appLocalization.name1, 4.0, '4 April, 20', appLocalization.content1),
      // Review(
      //     appLocalization.name3, 5.0, '23 Feb, 20', appLocalization.content2),
    ];

    for(dynamic rating in widget.ratings!) {
      print(rating);

      listOfReviews.add(Review(rating['username'], rating['start'], 'date', rating['description']));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: AppBar(
            titleSpacing: 0,
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.shopName!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Theme.of(context).secondaryHeaderColor)),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Color(0xff7ac81e),
                      size: 13,
                    ),
                    SizedBox(width: 8.0),
                    Text('${widget.ratingNumber}',
                        style: Theme.of(context)
                            .textTheme
                            .overline!
                            .copyWith(color: Color(0xff7ac81e))),
                    SizedBox(width: 8.0),
                    Text('${widget.numberOfReviews} reviews',
                        style: Theme.of(context).textTheme.overline),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 8.0,
                  color: Theme.of(context).cardColor,
                ),
              ],
            ),
          ),
        ),
      ),
      body: FadedSlideAnimation(
        child: ListView.builder(
            itemCount: listOfReviews.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listOfReviews[index].title??'',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(fontSize: 15.0),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Color(0xff7ac81e),
                            size: 13,
                          ),
                          SizedBox(width: 8.0),
                          Text(listOfReviews[index].rating.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(color: Color(0xff7ac81e))),
                          Spacer(),
                          Text(
                            listOfReviews[index].date,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                    fontSize: 11.7, color: Color(0xffd7d7d7)),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      listOfReviews[index].content!,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: Color(0xff6a6c74)),
                    )
                  ],
                ),
              );
            }),
        beginOffset: Offset(0.0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}