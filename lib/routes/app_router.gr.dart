// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i26;
import 'package:cloud_firestore/cloud_firestore.dart' as _i28;
import 'package:flutter/material.dart' as _i27;

import '../app.dart' as _i5;
import '../authentication/presentation/screens/edit_profile_screen.dart'
    as _i19;
import '../authentication/presentation/screens/location_screen.dart' as _i3;
import '../authentication/presentation/screens/login_screen.dart' as _i4;
import '../authentication/presentation/screens/register_screen.dart' as _i1;
import '../authentication/presentation/screens/verification_screen.dart' as _i2;
import '../home/presentation/screens/home_screen.dart' as _i23;
import '../home/presentation/screens/renterii_map_screen.dart' as _i18;
import '../orders/data/models/order.dart' as _i30;
import '../orders/presentations/screens/confirm_order_screen.dart' as _i6;
import '../orders/presentations/screens/my_orders_screen.dart' as _i24;
import '../orders/presentations/screens/order_map_screen.dart' as _i20;
import '../orders/presentations/screens/thank_you_screen.dart' as _i7;
import '../profile/presentation/screens/add_funds_screen.dart' as _i17;
import '../profile/presentation/screens/profile_screen.dart' as _i25;
import '../profile/presentation/screens/reviews_screen.dart' as _i22;
import '../profile/presentation/screens/settings_screen.dart' as _i8;
import '../profile/presentation/screens/support_screen.dart' as _i12;
import '../profile/presentation/screens/terms_conditions_screen.dart' as _i14;
import '../profile/presentation/screens/wallet_screen.dart' as _i13;
import '../rentals/presentation/screens/rating_screen.dart' as _i9;
import '../shops/data/models/shop.dart' as _i29;
import '../shops/presentation/screens/around_popular_shops.dart' as _i16;
import '../shops/presentation/screens/deals_screen.dart' as _i11;
import '../shops/presentation/screens/search_screen.dart' as _i21;
import '../shops/presentation/screens/shop_screen.dart' as _i10;
import '../shops/presentation/screens/shops_screen.dart' as _i15;

class AppRouter extends _i26.RootStackRouter {
  AppRouter([_i27.GlobalKey<_i27.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i26.PageFactory> pagesMap = {
    RegisterScreenRoute.name: (routeData) {
      final args = routeData.argsAs<RegisterScreenRouteArgs>(
          orElse: () => const RegisterScreenRouteArgs());
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData,
          child:
              _i1.RegisterScreen(key: args.key, phoneNumber: args.phoneNumber));
    },
    VerificationScreenRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.VerificationScreen());
    },
    LocationScreenRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.LocationScreen());
    },
    LoginScreenRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.LoginScreen());
    },
    AppRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.App());
    },
    ConfirmOrderScreenRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.ConfirmOrderScreen());
    },
    ThankYouScreenRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i7.ThankYouScreen());
    },
    SettingsScreenRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: _i8.SettingsScreen());
    },
    RatingScreenRoute.name: (routeData) {
      final args = routeData.argsAs<RatingScreenRouteArgs>();
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i9.RatingScreen(shop: args.shop, shopId: args.shopId));
    },
    ShopScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ShopScreenRouteArgs>();
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i10.ShopScreen(
              id: args.id,
              key: args.key,
              name: args.name,
              address: args.address,
              lat: args.lat,
              long: args.long,
              description: args.description,
              reference: args.reference,
              ratingArray: args.ratingArray,
              rating: args.rating,
              ratingNumber: args.ratingNumber,
              isBooking: args.isBooking));
    },
    DealsScreenRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: _i11.DealsScreen());
    },
    SupportPageRoute.name: (routeData) {
      final args = routeData.argsAs<SupportPageRouteArgs>(
          orElse: () => const SupportPageRouteArgs());
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i12.SupportPage(key: args.key, number: args.number));
    },
    WalletScreenRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i13.WalletScreen());
    },
    TermsAndConditionsScreenRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: _i14.TermsAndConditionsScreen());
    },
    ShopsScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ShopsScreenRouteArgs>();
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i15.ShopsScreen(
              key: args.key,
              pageTitle: args.pageTitle,
              isBooking: args.isBooking,
              categoryId: args.categoryId));
    },
    ShopsArroundPopularScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ShopsArroundPopularScreenRouteArgs>();
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i16.ShopsArroundPopularScreen(
              key: args.key,
              pageTitle: args.pageTitle,
              isBooking: args.isBooking,
              shops: args.shops));
    },
    AddFundsScreenRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i17.AddFundsScreen());
    },
    RenteriiMapScreenRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i18.RenteriiMapScreen());
    },
    EditProfileScreenRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i19.EditProfileScreen());
    },
    OrderMapScreenRoute.name: (routeData) {
      final args = routeData.argsAs<OrderMapScreenRouteArgs>();
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i20.OrderMapScreen(order: args.order, key: args.key));
    },
    SearchScreenRoute.name: (routeData) {
      final args = routeData.argsAs<SearchScreenRouteArgs>(
          orElse: () => const SearchScreenRouteArgs());
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i21.SearchScreen(key: args.key, isBooking: args.isBooking));
    },
    ReviewsScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ReviewsScreenRouteArgs>();
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i22.ReviewsScreen(
              key: args.key,
              shopName: args.shopName,
              username: args.username,
              ratingNumber: args.ratingNumber,
              ratings: args.ratings,
              numberOfReviews: args.numberOfReviews));
    },
    HomeScreenRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i23.HomeScreen());
    },
    MyOrdersScreenRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: _i24.MyOrdersScreen());
    },
    ProfileScreenRoute.name: (routeData) {
      return _i26.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i25.ProfileScreen());
    }
  };

  @override
  List<_i26.RouteConfig> get routes => [
        _i26.RouteConfig('/#redirect',
            path: '/', redirectTo: 'app', fullMatch: true),
        _i26.RouteConfig(RegisterScreenRoute.name, path: '/register-screen'),
        _i26.RouteConfig(VerificationScreenRoute.name,
            path: '/verification-screen'),
        _i26.RouteConfig(LocationScreenRoute.name, path: '/location-screen'),
        _i26.RouteConfig(LoginScreenRoute.name, path: '/login-screen'),
        _i26.RouteConfig(AppRoute.name, path: 'app', children: [
          _i26.RouteConfig(HomeScreenRoute.name,
              path: '', parent: AppRoute.name),
          _i26.RouteConfig(MyOrdersScreenRoute.name,
              path: 'my-orders-screen', parent: AppRoute.name),
          _i26.RouteConfig(ProfileScreenRoute.name,
              path: 'profile-screen', parent: AppRoute.name)
        ]),
        _i26.RouteConfig(ConfirmOrderScreenRoute.name,
            path: '/confirm-order-screen'),
        _i26.RouteConfig(ThankYouScreenRoute.name, path: '/thank-you-screen'),
        _i26.RouteConfig(SettingsScreenRoute.name, path: '/settings-screen'),
        _i26.RouteConfig(RatingScreenRoute.name, path: '/rating-screen'),
        _i26.RouteConfig(ShopScreenRoute.name, path: '/shop-screen'),
        _i26.RouteConfig(DealsScreenRoute.name, path: '/deals-screen'),
        _i26.RouteConfig(SupportPageRoute.name, path: '/support-page'),
        _i26.RouteConfig(WalletScreenRoute.name, path: '/wallet-screen'),
        _i26.RouteConfig(TermsAndConditionsScreenRoute.name,
            path: '/terms-and-conditions-screen'),
        _i26.RouteConfig(ShopsScreenRoute.name, path: '/shops-screen'),
        _i26.RouteConfig(ShopsArroundPopularScreenRoute.name,
            path: '/shops-arround-popular-screen'),
        _i26.RouteConfig(AddFundsScreenRoute.name, path: '/add-funds-screen'),
        _i26.RouteConfig(RenteriiMapScreenRoute.name,
            path: '/renterii-map-screen'),
        _i26.RouteConfig(EditProfileScreenRoute.name,
            path: '/edit-profile-screen'),
        _i26.RouteConfig(OrderMapScreenRoute.name, path: '/order-map-screen'),
        _i26.RouteConfig(RenteriiMapScreenRoute.name,
            path: '/renterii-map-screen'),
        _i26.RouteConfig(SearchScreenRoute.name, path: '/search-screen'),
        _i26.RouteConfig(ReviewsScreenRoute.name, path: '/reviews-screen')
      ];
}

/// generated route for
/// [_i1.RegisterScreen]
class RegisterScreenRoute extends _i26.PageRouteInfo<RegisterScreenRouteArgs> {
  RegisterScreenRoute({_i27.Key? key, String? phoneNumber})
      : super(RegisterScreenRoute.name,
            path: '/register-screen',
            args: RegisterScreenRouteArgs(key: key, phoneNumber: phoneNumber));

  static const String name = 'RegisterScreenRoute';
}

class RegisterScreenRouteArgs {
  const RegisterScreenRouteArgs({this.key, this.phoneNumber});

  final _i27.Key? key;

  final String? phoneNumber;

  @override
  String toString() {
    return 'RegisterScreenRouteArgs{key: $key, phoneNumber: $phoneNumber}';
  }
}

/// generated route for
/// [_i2.VerificationScreen]
class VerificationScreenRoute extends _i26.PageRouteInfo<void> {
  const VerificationScreenRoute()
      : super(VerificationScreenRoute.name, path: '/verification-screen');

  static const String name = 'VerificationScreenRoute';
}

/// generated route for
/// [_i3.LocationScreen]
class LocationScreenRoute extends _i26.PageRouteInfo<void> {
  const LocationScreenRoute()
      : super(LocationScreenRoute.name, path: '/location-screen');

  static const String name = 'LocationScreenRoute';
}

/// generated route for
/// [_i4.LoginScreen]
class LoginScreenRoute extends _i26.PageRouteInfo<void> {
  const LoginScreenRoute()
      : super(LoginScreenRoute.name, path: '/login-screen');

  static const String name = 'LoginScreenRoute';
}

/// generated route for
/// [_i5.App]
class AppRoute extends _i26.PageRouteInfo<void> {
  const AppRoute({List<_i26.PageRouteInfo>? children})
      : super(AppRoute.name, path: 'app', initialChildren: children);

  static const String name = 'AppRoute';
}

/// generated route for
/// [_i6.ConfirmOrderScreen]
class ConfirmOrderScreenRoute extends _i26.PageRouteInfo<void> {
  const ConfirmOrderScreenRoute()
      : super(ConfirmOrderScreenRoute.name, path: '/confirm-order-screen');

  static const String name = 'ConfirmOrderScreenRoute';
}

/// generated route for
/// [_i7.ThankYouScreen]
class ThankYouScreenRoute extends _i26.PageRouteInfo<void> {
  const ThankYouScreenRoute()
      : super(ThankYouScreenRoute.name, path: '/thank-you-screen');

  static const String name = 'ThankYouScreenRoute';
}

/// generated route for
/// [_i8.SettingsScreen]
class SettingsScreenRoute extends _i26.PageRouteInfo<void> {
  const SettingsScreenRoute()
      : super(SettingsScreenRoute.name, path: '/settings-screen');

  static const String name = 'SettingsScreenRoute';
}

/// generated route for
/// [_i9.RatingScreen]
class RatingScreenRoute extends _i26.PageRouteInfo<RatingScreenRouteArgs> {
  RatingScreenRoute({required dynamic shop, required String shopId})
      : super(RatingScreenRoute.name,
            path: '/rating-screen',
            args: RatingScreenRouteArgs(shop: shop, shopId: shopId));

  static const String name = 'RatingScreenRoute';
}

class RatingScreenRouteArgs {
  const RatingScreenRouteArgs({required this.shop, required this.shopId});

  final dynamic shop;

  final String shopId;

  @override
  String toString() {
    return 'RatingScreenRouteArgs{shop: $shop, shopId: $shopId}';
  }
}

/// generated route for
/// [_i10.ShopScreen]
class ShopScreenRoute extends _i26.PageRouteInfo<ShopScreenRouteArgs> {
  ShopScreenRoute(
      {required String id,
      _i27.Key? key,
      String? name,
      String? address,
      double? lat,
      double? long,
      String? description,
      dynamic reference,
      dynamic ratingArray,
      required String rating,
      required int ratingNumber,
      bool isBooking = false})
      : super(ShopScreenRoute.name,
            path: '/shop-screen',
            args: ShopScreenRouteArgs(
                id: id,
                key: key,
                name: name,
                address: address,
                lat: lat,
                long: long,
                description: description,
                reference: reference,
                ratingArray: ratingArray,
                rating: rating,
                ratingNumber: ratingNumber,
                isBooking: isBooking));

  static const String name = 'ShopScreenRoute';
}

class ShopScreenRouteArgs {
  const ShopScreenRouteArgs(
      {required this.id,
      this.key,
      this.name,
      this.address,
      this.lat,
      this.long,
      this.description,
      this.reference,
      this.ratingArray,
      required this.rating,
      required this.ratingNumber,
      this.isBooking = false});

  final String id;

  final _i27.Key? key;

  final String? name;

  final String? address;

  final double? lat;

  final double? long;

  final String? description;

  final dynamic reference;

  final dynamic ratingArray;

  final String rating;

  final int ratingNumber;

  final bool isBooking;

  @override
  String toString() {
    return 'ShopScreenRouteArgs{id: $id, key: $key, name: $name, address: $address, lat: $lat, long: $long, description: $description, reference: $reference, ratingArray: $ratingArray, rating: $rating, ratingNumber: $ratingNumber, isBooking: $isBooking}';
  }
}

/// generated route for
/// [_i11.DealsScreen]
class DealsScreenRoute extends _i26.PageRouteInfo<void> {
  const DealsScreenRoute()
      : super(DealsScreenRoute.name, path: '/deals-screen');

  static const String name = 'DealsScreenRoute';
}

/// generated route for
/// [_i12.SupportPage]
class SupportPageRoute extends _i26.PageRouteInfo<SupportPageRouteArgs> {
  SupportPageRoute({_i27.Key? key, String? number})
      : super(SupportPageRoute.name,
            path: '/support-page',
            args: SupportPageRouteArgs(key: key, number: number));

  static const String name = 'SupportPageRoute';
}

class SupportPageRouteArgs {
  const SupportPageRouteArgs({this.key, this.number});

  final _i27.Key? key;

  final String? number;

  @override
  String toString() {
    return 'SupportPageRouteArgs{key: $key, number: $number}';
  }
}

/// generated route for
/// [_i13.WalletScreen]
class WalletScreenRoute extends _i26.PageRouteInfo<void> {
  const WalletScreenRoute()
      : super(WalletScreenRoute.name, path: '/wallet-screen');

  static const String name = 'WalletScreenRoute';
}

/// generated route for
/// [_i14.TermsAndConditionsScreen]
class TermsAndConditionsScreenRoute extends _i26.PageRouteInfo<void> {
  const TermsAndConditionsScreenRoute()
      : super(TermsAndConditionsScreenRoute.name,
            path: '/terms-and-conditions-screen');

  static const String name = 'TermsAndConditionsScreenRoute';
}

/// generated route for
/// [_i15.ShopsScreen]
class ShopsScreenRoute extends _i26.PageRouteInfo<ShopsScreenRouteArgs> {
  ShopsScreenRoute(
      {_i27.Key? key,
      required String pageTitle,
      bool? isBooking,
      required _i28.DocumentReference<Object?> categoryId})
      : super(ShopsScreenRoute.name,
            path: '/shops-screen',
            args: ShopsScreenRouteArgs(
                key: key,
                pageTitle: pageTitle,
                isBooking: isBooking,
                categoryId: categoryId));

  static const String name = 'ShopsScreenRoute';
}

class ShopsScreenRouteArgs {
  const ShopsScreenRouteArgs(
      {this.key,
      required this.pageTitle,
      this.isBooking,
      required this.categoryId});

  final _i27.Key? key;

  final String pageTitle;

  final bool? isBooking;

  final _i28.DocumentReference<Object?> categoryId;

  @override
  String toString() {
    return 'ShopsScreenRouteArgs{key: $key, pageTitle: $pageTitle, isBooking: $isBooking, categoryId: $categoryId}';
  }
}

/// generated route for
/// [_i16.ShopsArroundPopularScreen]
class ShopsArroundPopularScreenRoute
    extends _i26.PageRouteInfo<ShopsArroundPopularScreenRouteArgs> {
  ShopsArroundPopularScreenRoute(
      {_i27.Key? key,
      required String pageTitle,
      bool? isBooking,
      required List<_i29.Shop> shops})
      : super(ShopsArroundPopularScreenRoute.name,
            path: '/shops-arround-popular-screen',
            args: ShopsArroundPopularScreenRouteArgs(
                key: key,
                pageTitle: pageTitle,
                isBooking: isBooking,
                shops: shops));

  static const String name = 'ShopsArroundPopularScreenRoute';
}

class ShopsArroundPopularScreenRouteArgs {
  const ShopsArroundPopularScreenRouteArgs(
      {this.key, required this.pageTitle, this.isBooking, required this.shops});

  final _i27.Key? key;

  final String pageTitle;

  final bool? isBooking;

  final List<_i29.Shop> shops;

  @override
  String toString() {
    return 'ShopsArroundPopularScreenRouteArgs{key: $key, pageTitle: $pageTitle, isBooking: $isBooking, shops: $shops}';
  }
}

/// generated route for
/// [_i17.AddFundsScreen]
class AddFundsScreenRoute extends _i26.PageRouteInfo<void> {
  const AddFundsScreenRoute()
      : super(AddFundsScreenRoute.name, path: '/add-funds-screen');

  static const String name = 'AddFundsScreenRoute';
}

/// generated route for
/// [_i18.RenteriiMapScreen]
class RenteriiMapScreenRoute extends _i26.PageRouteInfo<void> {
  const RenteriiMapScreenRoute()
      : super(RenteriiMapScreenRoute.name, path: '/renterii-map-screen');

  static const String name = 'RenteriiMapScreenRoute';
}

/// generated route for
/// [_i19.EditProfileScreen]
class EditProfileScreenRoute extends _i26.PageRouteInfo<void> {
  const EditProfileScreenRoute()
      : super(EditProfileScreenRoute.name, path: '/edit-profile-screen');

  static const String name = 'EditProfileScreenRoute';
}

/// generated route for
/// [_i20.OrderMapScreen]
class OrderMapScreenRoute extends _i26.PageRouteInfo<OrderMapScreenRouteArgs> {
  OrderMapScreenRoute({required _i30.Order order, _i27.Key? key})
      : super(OrderMapScreenRoute.name,
            path: '/order-map-screen',
            args: OrderMapScreenRouteArgs(order: order, key: key));

  static const String name = 'OrderMapScreenRoute';
}

class OrderMapScreenRouteArgs {
  const OrderMapScreenRouteArgs({required this.order, this.key});

  final _i30.Order order;

  final _i27.Key? key;

  @override
  String toString() {
    return 'OrderMapScreenRouteArgs{order: $order, key: $key}';
  }
}

/// generated route for
/// [_i21.SearchScreen]
class SearchScreenRoute extends _i26.PageRouteInfo<SearchScreenRouteArgs> {
  SearchScreenRoute({_i27.Key? key, bool? isBooking})
      : super(SearchScreenRoute.name,
            path: '/search-screen',
            args: SearchScreenRouteArgs(key: key, isBooking: isBooking));

  static const String name = 'SearchScreenRoute';
}

class SearchScreenRouteArgs {
  const SearchScreenRouteArgs({this.key, this.isBooking});

  final _i27.Key? key;

  final bool? isBooking;

  @override
  String toString() {
    return 'SearchScreenRouteArgs{key: $key, isBooking: $isBooking}';
  }
}

/// generated route for
/// [_i22.ReviewsScreen]
class ReviewsScreenRoute extends _i26.PageRouteInfo<ReviewsScreenRouteArgs> {
  ReviewsScreenRoute(
      {_i27.Key? key,
      required String? shopName,
      required String? username,
      required dynamic ratingNumber,
      required dynamic ratings,
      required dynamic numberOfReviews})
      : super(ReviewsScreenRoute.name,
            path: '/reviews-screen',
            args: ReviewsScreenRouteArgs(
                key: key,
                shopName: shopName,
                username: username,
                ratingNumber: ratingNumber,
                ratings: ratings,
                numberOfReviews: numberOfReviews));

  static const String name = 'ReviewsScreenRoute';
}

class ReviewsScreenRouteArgs {
  const ReviewsScreenRouteArgs(
      {this.key,
      required this.shopName,
      required this.username,
      required this.ratingNumber,
      required this.ratings,
      required this.numberOfReviews});

  final _i27.Key? key;

  final String? shopName;

  final String? username;

  final dynamic ratingNumber;

  final dynamic ratings;

  final dynamic numberOfReviews;

  @override
  String toString() {
    return 'ReviewsScreenRouteArgs{key: $key, shopName: $shopName, username: $username, ratingNumber: $ratingNumber, ratings: $ratings, numberOfReviews: $numberOfReviews}';
  }
}

/// generated route for
/// [_i23.HomeScreen]
class HomeScreenRoute extends _i26.PageRouteInfo<void> {
  const HomeScreenRoute() : super(HomeScreenRoute.name, path: '');

  static const String name = 'HomeScreenRoute';
}

/// generated route for
/// [_i24.MyOrdersScreen]
class MyOrdersScreenRoute extends _i26.PageRouteInfo<void> {
  const MyOrdersScreenRoute()
      : super(MyOrdersScreenRoute.name, path: 'my-orders-screen');

  static const String name = 'MyOrdersScreenRoute';
}

/// generated route for
/// [_i25.ProfileScreen]
class ProfileScreenRoute extends _i26.PageRouteInfo<void> {
  const ProfileScreenRoute()
      : super(ProfileScreenRoute.name, path: 'profile-screen');

  static const String name = 'ProfileScreenRoute';
}
