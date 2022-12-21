import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/app.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/routes/app_router.gr.dart';

import '../widgets/bottom_bar.dart';
import '../widgets/text_field.dart';

//Verification page that sends otp to the phone number entered on phone number page
class VerificationScreen extends StatelessWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          AppLocalizations.of(context)!.verification!,
          style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 18),
        ),
      ),
      body: FadedSlideAnimation(
        child: const OtpVerify(),
        beginOffset: const Offset(0.0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}

//otp verification class
class OtpVerify extends StatefulWidget {
  const OtpVerify({Key? key}) : super(key: key);

  @override
  _OtpVerifyState createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final TextEditingController _controller = TextEditingController();

  // VerificationBloc _verificationBloc;
  bool isDialogShowing = false;
  int _counter = 20;
  late Timer _timer;

  _startTimer() {
    //shows timer
    _counter = 30; //time counter

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _counter > 0 ? _counter-- : _timer.cancel();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void verifyPhoneNumber() {
    context.read<UserCubit>().verifyOTP(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state.status == UserStatus.loginSuccess &&
            state.isNewUser == false) {
          context.router.pushAndPopUntil(const AppRoute(), predicate: (_)=>false);
        } else if (state.status == UserStatus.loginSuccess &&
            state.isNewUser == true) {
          context.router.replace(RegisterScreenRoute());
        } else if (state.status == UserStatus.loginOtpReSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('We resent you the OTP code'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Divider(
                color: Theme.of(context).cardColor,
                thickness: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  AppLocalizations.of(context)!.enterVerification!,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 22,
                      color: Theme.of(context).secondaryHeaderColor),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                // child: EntryField(
                //  // controller: _controller,
                //   readOnly: false,
                //   label: AppLocalizations.of(context).verificationCode,
                //   maxLength: 6,
                //   keyboardType: TextInputType.number,
                //   initialValue: '123456',
                // ),
                child: EntryField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    label: AppLocalizations.of(context)!.verificationCode,
                    title: '5 7 9 6 4 4'),
              ),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '00:$_counter min',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                        shape:
                            const RoundedRectangleBorder(side: BorderSide.none),
                        padding: const EdgeInsets.all(24.0),
                      ),
                      child: FadedScaleAnimation(
                        child: Text(
                          AppLocalizations.of(context)!.resend!,
                          style: TextStyle(
                            fontSize: 16.7,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        fadeDuration: const Duration(milliseconds: 800),
                      ),
                      onPressed: _counter < 1
                          ? () {
                              context.read<UserCubit>().resendOTP();
                            }
                          : null),
                ],
              ),
              BottomBar(
                  text: AppLocalizations.of(context)!.continueText,
                  onTap: () {
                    verifyPhoneNumber();
                  }),
            ],
          )
        ],
      ),
    );
  }
}
