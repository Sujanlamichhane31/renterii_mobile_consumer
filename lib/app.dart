import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:renterii/routes/app_router.gr.dart';

import 'Themes/colors.dart';
import 'authentication/business_logic/cubit/user/user_cubit.dart';
import 'authentication/presentation/screens/login_screen.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.pulse
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 40.0
      ..radius = 5.0
      ..progressColor = Colors.black
      ..backgroundColor = kMainColor
      ..indicatorColor = Colors.black
      ..textColor = Colors.black
      ..maskType = EasyLoadingMaskType.black
      // ..maskColor = Colors.black.withOpacity(0.5)
      ..userInteractions = false
      ..dismissOnTap = false;
  }

  @override
  Widget build(context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        final loginStatus = context.read<UserCubit>().state.status;
        if (snapshot.hasData || loginStatus == UserStatus.logout) {
          return const LoginScreen();
        } else {
          return AutoTabsScaffold(
            routes: const [
              HomeScreenRoute(),
              MyOrdersScreenRoute(),
              ProfileScreenRoute(),
            ],
            bottomNavigationBuilder: (_, tabsRouter) {
              return BottomNavigationBar(
                type: BottomNavigationBarType.shifting,
                showUnselectedLabels: true,
                showSelectedLabels: true,
                unselectedItemColor: Colors.black,
                selectedItemColor: kMainColor,
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold),
                currentIndex: tabsRouter.activeIndex,
                onTap: tabsRouter.setActiveIndex,
                items: [
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child:
                            SvgPicture.asset('images/logo_svg.svg', width: 30),
                      ),
                      label: 'Rentals',
                      activeIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: SvgPicture.asset('images/logo_svg_colored.svg',
                            width: 30),
                      )),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: 'Profile'),
                ],
              );
            },
          );
        }
      },
    );
  }
}
