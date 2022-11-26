import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/profile/presentation/widgets/text_field.dart';
import 'package:renterii/rentals/presentation/widgets/bottom_bar.dart';
import 'package:renterii/theme_cubit.dart';
import 'package:renterii/utils/extension.dart';

class SupportPage extends StatefulWidget {
  static const String id = 'support_page';
  final String? number;

  SupportPage({Key? key, this.number}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  TextEditingController _numberController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  GlobalKey<FormState> supportPageKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    _numberController = TextEditingController();
    _messageController = TextEditingController();
    super.initState();
  }

  // Future sendMail(
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
                              child: Form(
                                key: supportPageKey,
                                child: Column(
                                  children: [
                                    inputField(
                                        title: AppLocalizations.of(context)!
                                            .mobileNumber!,
                                        hint: '+1 987 654 3210',
                                        img: 'images/icons/mobile.png',
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Mobile Number is required';
                                          } else if (value.isValidNumber()) {
                                            return 'Please enter valid number';
                                          }
                                          {
                                            return null;
                                          }
                                        },
                                        controller: _numberController),
                                    inputField(
                                        title: AppLocalizations.of(context)!
                                            .message!,
                                        hint: "Enter your message here",
                                        img: 'images/icons/message.png',
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return 'Message is empty';
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: _messageController),
                                  ],
                                ),
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
                if (supportPageKey.currentState!.validate()) {
                  supportPageKey.currentState!.save();

                  // sendMail(phone: phone, message: message, context: context);
                  'hello@renterii.com'.sendMail(
                      body:
                          "Respected sir/Madam,\n\n \nPhone Number - ${_numberController.text}\n\n\n ${_messageController.text}\n\nRegards,\n ",
                      subject: 'Message about the application');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Container inputField(
      {String? title,
      String? hint,
      String? img,
      String? Function(String?)? validator,
      required TextEditingController controller}) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 20,
                child: Image(
                  image: AssetImage(
                    img ?? '',
                  ),
                  color: kMainColor,
                ),
              ),
              const SizedBox(
                width: 13,
              ),
              Text(title ?? '',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12))
            ],
          ),
          Container(
            padding: const EdgeInsets.only(left: 25),
            child: Column(
              children: [
                SmallTextFormField(
                  title: hint,
                  validator: validator,
                  controller: controller,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
