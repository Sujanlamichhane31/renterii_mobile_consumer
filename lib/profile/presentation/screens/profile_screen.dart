import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/authentication/presentation/widgets/image_upload.dart';
import 'package:renterii/profile/presentation/screens/profile_edit_screen.dart';
import 'package:renterii/profile/presentation/screens/settings_screen.dart';
import 'package:renterii/profile/presentation/screens/support_screen.dart';
import 'package:renterii/profile/presentation/screens/wallet_screen.dart';
import 'package:renterii/profile/presentation/widgets/list_tile.dart';
import 'package:renterii/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.account!,
              style: Theme.of(context).textTheme.bodyText1),
          centerTitle: true,
        ),
        body: const Account(),
       
      );
}

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String? number;

  @override
  void initState() {
    super.initState();
  }

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    late ThemeCubit _themeCubit;
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    return ListView(
      children: <Widget>[
        const UserDetails(),
        Divider(
          color: Theme.of(context).cardColor,
          thickness: 8.0,
        ),
        BuildListTile(
          small: true,
          image: 'images/earnings_icon.png',
          text: AppLocalizations.of(context)!.wallet,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const WalletScreen())),
        ),
        // AddressTile(),
        // BuildListTile(
        //   small: true,
        //   image: 'images/account/ic_menu_favorite.png',
        //   text: AppLocalizations.of(context)!.fav,
        //   onTap: () =>
        //       Navigator.pushNamed(context, PageRoutes.favourite), // favourite
        // ),
        BuildListTile(
          small: true,
          image: 'images/account/profile.png',
          text: 'Edit profile',
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const ProfileEditPage())),
        ),
        BuildListTile(
            small: true,
            image: 'images/terms_and_conditions_icon.png',
            text: AppLocalizations.of(context)!.tnc,
            onTap: () => _launchURL('https://www.renterii.com/terms')),
        BuildListTile(
          small: true,
          image: 'images/support_icon.png',
          text: AppLocalizations.of(context)!.support,
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SupportPage())),
        ),
        BuildListTile(
          small: true,
          image: 'images/setting_icon.png',
          text: AppLocalizations.of(context)!.settings,
          // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen())),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => SettingsScreen())),
        ),
        const LogoutTile(),
        // if (AppConfig.isDemoMode)
        //     BuyThisApp.button(
        //       AppConfig.appName,
        //       'https://dashboard.vtlabs.dev/projects/envato-referral-buy-link?project_slug=hungerz_flutter',
        //     ),
        //   if (AppConfig.isDemoMode)
        //     Divider(
        //       color: Theme.of(context).cardColor,
        //       thickness: 5.0,
        //     ),
        //   if (AppConfig.isDemoMode)
        //     _themeCubit.isDark
        //           ? BuyThisApp.developerRowOpusDark(
        //               Colors.transparent, Theme.of(context).primaryColorLight)
        //           : BuyThisApp.developerRowOpus(
        //               Colors.transparent, Theme.of(context).secondaryHeaderColor),
      ],
    );
  }
}

class AddressTile extends StatelessWidget {
  const AddressTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BuildListTile(
        small: true,
        image: 'images/account/ic_menu_addressact.png',
        text: AppLocalizations.of(context)!.saved,
        onTap: () =>
            Navigator.pushNamed(context, PageRoutes.savedAddressesPage),
      );
}

class LogoutTile extends StatelessWidget {
  const LogoutTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (_, currState) => currState.status == UserStatus.logout,
      listener: (context, state) {
        context.router.pop(context);
      },
      child: BuildListTile(
        small: true,
        image: 'images/logout_icon.png',
        text: AppLocalizations.of(context)!.logout,
        onTap: () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.loggingOut!),
            content: Text(AppLocalizations.of(context)!.areYouSure!),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: kTransparentColor)),
                ),
                child: Text(
                  AppLocalizations.of(context)!.no!,
                  style: TextStyle(
                    color: kMainColor,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.yes!,
                  style: TextStyle(
                    color: kMainColor,
                  ),
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: kTransparentColor)),
                ),
                onPressed: () async {
                  context.read<UserCubit>().logout();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('isLoggedin');
                  context.router.replaceNamed('app');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ProfileImage(
              //   size: 36.0,
              //   imageUrl: state.user.photoUrl,
              //   isUpdating: false,
              // ),
              ImageUpload(
                imageUrl: state.user.photoUrl,
                isUpdating: false,
                size: 36.0,
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '\n${state.user.name}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 20),
                  ),
                  state.user.phoneNumber != null && state.user.phoneNumber != ''
                      ? Text(
                          '\n${state.user.phoneNumber ?? ''}',
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                    color: const Color(0xff9a9a9a),
                                  ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    state.user.email ?? '',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: const Color(0xff9a9a9a),
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
