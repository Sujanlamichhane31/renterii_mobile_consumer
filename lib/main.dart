import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:renterii/authentication/business_logic/cubit/signup/signup_cubit.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/authentication/data/data_providers/auth_data_provider.dart';
import 'package:renterii/authentication/data/data_providers/wallet_data_provider.dart';
import 'package:renterii/authentication/data/repositories/auth_repository.dart';
import 'package:renterii/authentication/data/repositories/wallet_repository.dart';
import 'package:renterii/home/business_logic/cubit/category_cubit.dart';
import 'package:renterii/home/data/data_provider/home_data_provider.dart';
import 'package:renterii/home/data/repositories/home_repository.dart';
import 'package:renterii/language_cubit.dart';
import 'package:renterii/orders/business_logic/cubit/order_cubit.dart';
import 'package:renterii/orders/data/data_providers/order_data_provider.dart';
import 'package:renterii/orders/data/repositories/order_repository.dart';
import 'package:renterii/shops/business_logic/cubit/cubit/deals_cubit.dart';
import 'package:renterii/shops/business_logic/cubit/product/product_cubit.dart';
import 'package:renterii/shops/business_logic/cubit/shop_cubit.dart';
import 'package:renterii/shops/data/data_providers/deal_data_provider.dart';
import 'package:renterii/shops/data/data_providers/product_data_provider.dart';
import 'package:renterii/shops/data/data_providers/shop_data_provider.dart';
import 'package:renterii/shops/data/repositories/deal_repository.dart';
import 'package:renterii/shops/data/repositories/product_repository.dart';
import 'package:renterii/shops/data/repositories/shop_repository.dart';
import 'package:renterii/theme_cubit.dart';

import 'Locale/locales.dart';
import 'firebase_options.dart';
import 'map_utils.dart';
import 'routes/app_router.gr.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stripe.publishableKey =
      'pk_test_51HyNgHFrhUhdspsNoy51wwkLmo85l7Bes8dZCcSizS2Pzk9CpgdsBB94R1Q17Jrd0UfI4aEjEeXlNGRZLaIQJgtb00TpglSgsb';

  Stripe.merchantIdentifier = 'renterii';

  await Stripe.instance.applySettings();

  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  HydratedBlocOverrides.runZoned(
    () => runApp(Renterii()),
    storage: storage,
  );

  MapUtils.getMarkerPic();
}

class Renterii extends StatelessWidget {
  final _appRouter = AppRouter();
  final _userCubit = UserCubit(
    authRepository: AuthRepository(
      authDataProvider: AuthDataProvider(),
    ),
    walletRepository: WalletRepository(
      walletDataProvider: WalletDataProvider(),
    ),
  );

  Renterii({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<UserCubit>(create: (context) => _userCubit),
          BlocProvider<LanguageCubit>(
            create: (context) => LanguageCubit()..getCurrentLanguage(),
          ),
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit()..getCurrentTheme(),
          ),
          BlocProvider(
            create: (ctx) => SignupCubit(
              authRepository: AuthRepository(
                authDataProvider: AuthDataProvider(),
              ),
              userCubit: _userCubit,
            ),
          ),
          BlocProvider<CategoryCubit>(
            create: (context) => CategoryCubit(
                HomeRepository(homeDataProvider: HomeDataProvider()))
              ..getAllCategories(),
          ),
          BlocProvider<DealsCubit>(
              create: (context) => DealsCubit(
                    dealRepository:
                        DealRepository(dealDataProvider: DealDataProvider()),
                  )..getAllDeals()),
          BlocProvider<OrderCubit>(
              create: (context) => OrderCubit(
                    OrderRepository(orderDataProvider: OrderDataProvider()),
                  )),
          BlocProvider<ShopCubit>(
            create: (context) => ShopCubit(
              ShopRepository(
                shopDataProvider: ShopDataProvider(),
              ),
            )..getAllShops(),
          ),
          BlocProvider<ProductCubit>(
            create: (context) => ProductCubit(
              productRepository: ProductRepository(
                productDataProvider: ProductDataProvider(),
              ),
            ),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeData>(
          builder: (_, theme) => BlocBuilder<LanguageCubit, Locale>(
            builder: (_, locale) =>
                // MaterialApp(
                //       locale: locale,
                //       theme: theme,
                //       localizationsDelegates: const [
                //         AppLocalizationsDelegate(),
                //         GlobalMaterialLocalizations.delegate,
                //         GlobalCupertinoLocalizations.delegate,
                //         GlobalWidgetsLocalizations.delegate,
                //       ],
                //       supportedLocales: AppLocalizations.getSupportedLocales(),
                //       debugShowCheckedModeBanner: false,
                //       builder: EasyLoading.init(),
                //       home: RegisterScreen(),
                //     )
                MaterialApp.router(
              routerDelegate: _appRouter.delegate(),
              routeInformationParser: _appRouter.defaultRouteParser(),
              localizationsDelegates: const [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.getSupportedLocales(),
              debugShowCheckedModeBanner: false,
              locale: locale,
              theme: theme,
              builder: EasyLoading.init(),
            ),
          ),
        ),
      );
}
