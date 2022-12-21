import 'package:auto_route/auto_route.dart';
import 'package:renterii/authentication/presentation/screens/login_screen.dart';
import 'package:renterii/authentication/presentation/screens/register_screen.dart';
import 'package:renterii/authentication/presentation/screens/verification_screen.dart';
import 'package:renterii/home/presentation/screens/home_screen.dart';
import 'package:renterii/home/presentation/screens/renterii_map_screen.dart';
import 'package:renterii/orders/presentations/screens/confirm_order_screen.dart';
import 'package:renterii/orders/presentations/screens/order_map_screen.dart';
import 'package:renterii/orders/presentations/screens/thank_you_screen.dart';
import 'package:renterii/profile/presentation/screens/add_funds_screen.dart';
import 'package:renterii/profile/presentation/screens/profile_screen.dart';
import 'package:renterii/profile/presentation/screens/settings_screen.dart';
import 'package:renterii/profile/presentation/screens/support_screen.dart';
import 'package:renterii/profile/presentation/screens/terms_conditions_screen.dart';
import 'package:renterii/profile/presentation/screens/wallet_screen.dart';
import 'package:renterii/shops/presentation/screens/deals_screen.dart';
import 'package:renterii/shops/presentation/screens/search_screen.dart';
import 'package:renterii/shops/presentation/screens/shop_screen.dart';

import '../app.dart';
import '../authentication/presentation/screens/edit_profile_screen.dart';
import '../authentication/presentation/screens/location_screen.dart';
import '../orders/presentations/screens/my_orders_screen.dart';
import '../profile/presentation/screens/reviews_screen.dart';
import '../rentals/presentation/screens/rating_screen.dart';
import '../shops/presentation/screens/around_popular_shops.dart';
import '../shops/presentation/screens/shops_screen.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: RegisterScreen),
    AutoRoute(page: VerificationScreen),
    AutoRoute(page: LocationScreen),
    AutoRoute(
      page: LoginScreen,
    ),
    AutoRoute(
      path: 'app',
      page: App,
      initial: true,
      children: [
        AutoRoute(page: HomeScreen, initial: true),
        AutoRoute(page: MyOrdersScreen),
        AutoRoute(page: ProfileScreen),
      ],
    ),
    AutoRoute(page: ConfirmOrderScreen),
    AutoRoute(page: ThankYouScreen),
    AutoRoute(page: SettingsScreen),
    AutoRoute(page: RatingScreen),
    AutoRoute(page: ShopScreen),
    AutoRoute(page: DealsScreen),
    AutoRoute(page: SupportPage),
    AutoRoute(page: WalletScreen),
    AutoRoute(page: TermsAndConditionsScreen),
    AutoRoute(page: ShopsScreen),
    AutoRoute(page: ShopsArroundPopularScreen),
    AutoRoute(page: AddFundsScreen),
    AutoRoute(page: RenteriiMapScreen),
    AutoRoute(
      page: EditProfileScreen,
    ),
    AutoRoute(page: OrderMapScreen),
    AutoRoute(
      page: RenteriiMapScreen,
    ),
    AutoRoute(
      page: SearchScreen,
    ),
    AutoRoute(
      page: ReviewsScreen,
    ),
  ],
)
class $AppRouter {}
