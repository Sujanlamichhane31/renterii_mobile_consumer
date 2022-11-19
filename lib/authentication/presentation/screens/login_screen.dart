import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/routes/app_router.gr.dart';
import 'package:renterii/theme_cubit.dart';

import '../widgets/mobile_input.dart';

//first page that takes phone number as input for verification
class LoginScreen extends StatefulWidget {
  static const String id = 'phone_number';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _otpTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) async {
          if (state.status == UserStatus.loginGoogleSuccess &&
              state.isNewUser) {
            context.router.replace(RegisterScreenRoute());
          } else if (state.status == UserStatus.loginGoogleSuccess &&
              !state.isNewUser) {
            context.router.replaceNamed('app');
          } else if (state.status == UserStatus.loginOtpSent) {
            context.router.push(
              const VerificationScreenRoute(),
            );
          }
        },
        child: SafeArea(
          child: FadedSlideAnimation(
            child: SingleChildScrollView(
              //used for scrolling when keyboard pops up
              child: Container(
                color: Theme.of(context).cardColor,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const Spacer(),
                    Expanded(
                      flex: 2,
                      child: FadedScaleAnimation(
                        child: Image.asset(
                          BlocProvider.of<ThemeCubit>(context).isDark
                              ? "images/renterii_logo_white.png"
                              : "images/renterii_logo_black.png",
                          height: 20,
                          width: 340,
                        ),
                        fadeDuration: const Duration(milliseconds: 300),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        "images/renterii_girl.png", //footer image
                      ),
                    ),
                    const Spacer(),
                    const MobileInput(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 32.0,
                        color: Theme.of(context).cardColor,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.or!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    fontSize: 15, color: Colors.blueGrey[800]),
                          ),
                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     // TODO
                    //     // Navigator.pushNamed(context, LoginRoutes.socialLogin),
                    //   },
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 64.0,
                    //     color: const Color(0xff3a559f),
                    //     child: Row(
                    //       children: [
                    //         SizedBox(
                    //           width: MediaQuery.of(context).size.width * 0.23,
                    //         ),
                    //         Image.asset(
                    //           'images/ic_login_facebook.png',
                    //           height: 19.0,
                    //           width: 19.7,
                    //         ),
                    //         const SizedBox(
                    //           width: 34.0,
                    //         ),
                    //         Text(AppLocalizations.of(context)!.continueWith!,
                    //             style: Theme.of(context)
                    //                 .textTheme
                    //                 .caption!
                    //                 .copyWith(color: kWhiteColor)),
                    //         Text(AppLocalizations.of(context)!.facebook!,
                    //             style: Theme.of(context)
                    //                 .textTheme
                    //                 .caption!
                    //                 .copyWith(
                    //                     color: kWhiteColor,
                    //                     fontWeight: FontWeight.bold)),
                    //         const Spacer(),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    InkWell(
                      onTap: () async {
                        context.read<UserCubit>().loginWithGoogle();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 64.0,
                        color: kWhiteColor,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.23,
                            ),
                            Image.asset('images/ic_login_google.png',
                                height: 19.0, width: 19.7),
                            const SizedBox(
                              width: 34.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.continueWith!,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(color: kMainTextColor),
                            ),
                            Text(AppLocalizations.of(context)!.google!,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: kMainTextColor)),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     // TODO
                    //     // Navigator.pushNamed(context, LoginRoutes.socialLogin),
                    //   },
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 64.0,
                    //     color: const Color(0xff000000),
                    //     child: Row(
                    //       children: [
                    //         SizedBox(
                    //           width: MediaQuery.of(context).size.width * 0.23,
                    //         ),
                    //         Image.asset('images/ic_login_apple.png',
                    //             height: 19.0, width: 19.7),
                    //         const SizedBox(
                    //           width: 34.0,
                    //         ),
                    //         Text(AppLocalizations.of(context)!.continueWith!,
                    //             style: Theme.of(context)
                    //                 .textTheme
                    //                 .caption!
                    //                 .copyWith(color: kWhiteColor)),
                    //         Text(AppLocalizations.of(context)!.apple!,
                    //             style: Theme.of(context)
                    //                 .textTheme
                    //                 .caption!
                    //                 .copyWith(
                    //                     color: kWhiteColor,
                    //                     fontWeight: FontWeight.bold)),
                    //         const Spacer(),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
              ),
            ),
            beginOffset: const Offset(0.0, 0.3),
            endOffset: const Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
          ),
        ),
      ),
    );
  }
}
