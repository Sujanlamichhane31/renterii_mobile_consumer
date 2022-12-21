import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//import 'package:renrerii/Components/bottom_bar.dart';
//import 'package:renterii/Components/textfield.dart';

import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/routes/app_router.gr.dart';
import 'package:renterii/shops/business_logic/cubit/shop_cubit.dart';
import 'package:renterii/utils/extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../authentication/presentation/widgets/bottom_bar.dart';

class RatingScreen extends StatefulWidget {
  final dynamic shop;
  final String shopId;
  RatingScreen({required this.shop, required this.shopId});
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  TextEditingController _controller = TextEditingController();

  double? rating;
  String id = '';
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = sharedPreferences.getString("userId") ?? '';
  }

  @override
  initState() {
    super.initState();
    getid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: AppBar(
            titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: Text(AppLocalizations.of(context)!.rate!,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kMainTextColor)),
          ),
        ),
      ),
      body: FadedSlideAnimation(
        child: Stack(
          children: [
            ListView(
              children: [
                Text(
                  AppLocalizations.of(context)!.how!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  AppLocalizations.of(context)!.withR!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: FadedScaleAnimation(
                    child: Image.network(
                      widget.shop['imageUrl'],
                      height: 83.3,
                      width: 83.3,
                      // color: Colors.amber,
                    ),
                    fadeDuration: const Duration(milliseconds: 800),
                  ),
                ),
                Text(
                  widget.shop['name'],
                  //AppLocalizations.of(context)!.store!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 15.0),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  AppLocalizations.of(context)!.type!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 10.0, color: const Color(0xff888888)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 44.0),
                  child: Center(
                    child: RatingBar.builder(
                      minRating: 1,
                      itemCount: 5,
                      glowColor: kTransparentColor,
                      unratedColor: const Color(0xffe6e6e6),
                      onRatingUpdate: (value) {
                        rating = value;
                      },
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: kMainColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.addReview!.toUpperCase(),
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 11.0,
                          color: const Color(0xff838383),
                          letterSpacing: 0.5),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.multiline,
                      keyboardAppearance: Brightness.light,
                      minLines: 1,
                      maxLines: 6,
                      maxLength: 120,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BlocListener<ShopCubit, ShopState>(
                listener: (BuildContext context, ShopState state) {
                  if (state is RatingState) {
                    if (state.isFailure) {
                      context.showFailureSnack("Operation failed! Try again.");
                    }
                    if (state.isSuccess) {
                      _controller.dispose();
                      context.router.push(const HomeScreenRoute());
                    }
                  }
                },
                child: BottomBar(
                    onTap: () {
                      print(_controller.value.text);
                      final newRating = Rating(
                          start: rating,
                          description: _controller.value.text,
                          userId: id);
                      context
                          .read<ShopCubit>()
                          .newRating(widget.shopId, newRating);
                      // context.router.pushNamed('app');
                      Navigator.pop(context);
                    },
                    text: AppLocalizations.of(context)!.feedback),
              ),
            )
          ],
        ),
        beginOffset: const Offset(0.0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}

class Rating {
  final dynamic start;
  final String description;
  final String userId;

  const Rating(
      {required this.start, required this.description, required this.userId});
}
