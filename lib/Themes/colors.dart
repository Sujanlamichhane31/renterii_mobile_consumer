import 'package:flutter/material.dart';

// Color kMainColor = Color(0xfffbaf03);
Color kMainColor = const Color(0xFFF3CFC6);
MaterialColor kMainSwatchColor = MaterialColor(
  kMainColor.value,
  <int, Color>{
    50: const Color(0xFFFFF5E1),
    100: const Color(0xFFFEE7B3),
    200: const Color(0xFFFDD781),
    300: const Color(0xFFFCC74F),
    400: const Color(0xFFFCBB29),
    500: kMainColor,
    600: const Color(0xFFFAA803),
    700: const Color(0xFFFA9F02),
    800: const Color(0xFFF99602),
    900: const Color(0xFFF88601),
  },
);
Color kDisabledColor = const Color(0xff616161);
Color kWhiteColor = Colors.white;
Color kLightTextColor = const Color(0xff6a6c74);
Color kCardBackgroundColor = const Color(0xfff8f9fd);
Color kTransparentColor = Colors.transparent;
Color kMainTextColor = const Color(0xff000000);
Color kIconColor = const Color(0xff999e93);
Color kHintColor = const Color(0xff6a6c74);
Color kTextColor = const Color(0xff6a6c74);
Color unselectedLabelColor = const Color(0xff515565);
