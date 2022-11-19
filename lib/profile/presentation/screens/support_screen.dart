import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/profile/presentation/widgets/text_field.dart';
import 'package:renterii/rentals/presentation/widgets/bottom_bar.dart';
import 'package:renterii/theme_cubit.dart';

class SupportPage extends StatelessWidget {
  final String? number;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  SupportPage({
    Key? key,
    this.number,
  }) : super(key: key);

  Future sendMail(
      {required String phone,
      required String message,
      BuildContext? context}) async {
    if (phone.isNotEmpty && message.isNotEmpty) {
      const serviceId = 'service_cu7pvvj';
      const templateId = 'template_jj20nuo';
      const userId = 'eGdURSuqA3ZPJ8FDJ';
      const accessToken = 'z74l-dtqXCieWkDtkWAMb';
      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': userId,
            'accessToken': accessToken,
            'template_params': {'from_name': phone, 'message': message}
          }));
    } else {
      const snackBar = SnackBar(
          content: Text('Please, fill out all necessary information!'));
      ScaffoldMessenger.of(context!).showSnackBar(snackBar);
    }
  }

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
        title: Text(AppLocalizations.of(context)!.support!,
            style: Theme.of(context).textTheme.bodyText1),
      ),
      body: Stack(
        children: [
          FadedSlideAnimation(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 48.0),
                        color: Theme.of(context).cardColor,
                        child: FadedScaleAnimation(
                          child: Image(
                            image: AssetImage(
                                BlocProvider.of<ThemeCubit>(context).isDark
                                    ? "images/logo.png"
                                    : "images/logo.png"),
                            height: 35.0,
                            // width: 59.7,
                          ),
                          fadeDuration: const Duration(milliseconds: 800),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24.0,
                          horizontal: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                top: 16.0,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.orWrite!,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                bottom: 16.0,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.yourWords!,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                children: [
                                  inputField(
                                      AppLocalizations.of(context)!
                                          .mobileNumber!,
                                      '+1 987 654 3210',
                                      'images/icons/ic_phone.png',
                                      phoneController!),
                                  inputField(
                                      AppLocalizations.of(context)!.message!,
                                      AppLocalizations.of(context)!
                                          .enterMessage,
                                      'images/icons/ic_mail.png',
                                      messageController!),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                      // Spacer(),
                    ],
                  ),
                ),
              ),
            ),
            beginOffset: const Offset(0.0, 0.3),
            endOffset: const Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomBar(
              text: 'Submit',
              // text: AppLocalizations.of(context)!.submit,
              onTap: () {
                String phone = phoneController.text;
                String message = messageController.text;
                sendMail(phone: phone, message: message, context: context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Column inputField(String title, String? hint, String img,
      TextEditingController controller) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              height: 20,
              child: Image(
                image: AssetImage(
                  img,
                ),
                color: kMainColor,
              ),
            ),
            const SizedBox(
              width: 13,
            ),
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12))
          ],
        ),
        Container(
          padding: const EdgeInsets.only(left: 33),
          child: Column(
            children: [
              SmallTextFormField(null, hint, controller),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
