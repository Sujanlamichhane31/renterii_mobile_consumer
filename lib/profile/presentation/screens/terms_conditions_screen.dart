import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/theme_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

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
        title: Text(AppLocalizations.of(context)!.tnc!,
            style: Theme.of(context).textTheme.bodyText1),
      ),
      body: FadedSlideAnimation(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(48.0),
                color: Theme.of(context).cardColor,
                child: FadedScaleAnimation(
                  child: Image(
                    image: AssetImage(
                        BlocProvider.of<ThemeCubit>(context).isDark
                            ? "images/logo.png"
                            : "images/logo.png"),
                    height: 130.0,
                    width: 99.7,
                  ),
                  fadeDuration: const Duration(milliseconds: 800),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 28.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.termsOfUse!,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '\nBy signing up for a Renterii Account (as defined in Section 2) or by using any Renterii Service (defined in Section 1), you are agreeing to be bound by the following terms and conditions (the “Terms of Service”).\nAs used in these Terms of Service:,\nAccount” has the meaning described in Section 2;\nApplication” means the piece of software created by Renterii Inc. to facilitate online peer-to-peer rentals from a mobile device;.\nBilling Information” has the meaning described in Section 2;\nBooking Deposit” has the meaning described in Section 7;\nBooking Fees” has the meaning described in Section 7;\nChargeback” or “credit Chargeback” has the meaning described in Section 7;\n“Contribution” has the meaning described in Section 3;\n“Damage Deposit” has the meaning described in Section 7;\n“including” and “includes” mean including and includes without limiting the generality of the foregoing;\n“Items” has the meaning described in Section 1;\n“Late Fees” has the meaning described in Section 7;\n“Lender” has the meaning described in Section 1;\n“Listings” has the meaning described in Section 3;\n“Payment Information” has the meaning described in Section 2;\n“Payment Processes” has the meaning described in Section 2;\n“Personal Information” has the meaning described in Section 2;\n“Renter” has the meaning defined and described in general in Section 1, including any new features which may be added to the current Services in the future;\n“Services” has the meaning described in Section 2;\n“Payment Issues” has the meaning described in Section 7;\n“Transactions Fees” has the meaning described in Section 7;\n“User”, whether used singular or plural, and whether capitalized or not, means End Users who use either the Application, Website or Services;\n“we”, “us” and “Renterii” means Renterii Inc., a Canadian corporation, with offices located at 441-100 Innovation Dr, Winnipeg, MB R3T 6G2, Canada\nAny new features or tools which are added to the current Services shall be also subject to the Terms of Service. Renterii reserves the right to update and change these Terms of Services without notice to its Users. You are advised to check the Terms of Service from time to time for any updates or changes that may impact you and if you do not accept such amendments, you must cease using the Services.',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Center(
                        child: InkWell(
                      child: const Text('Read More'),
                      onTap: () => launch('https://renterii.com/terms/'),
                    ))
                    // Text(
                    //   AppLocalizations.of(context)!.companyPolicy!,
                    //   style: Theme.of(context).textTheme.bodyText1,
                    // ),
                    // Text(
                    //   '\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pulvinar porta sagittis. Sed id varius magna. Etiam felis neque, gravida vitae elementum non, consequat eu odio. Mauris cursus commodo nisi sed imperdiet. Fusce vitae vehicula ipsum, ut commodo lorem. Praesent interdum blandit condimentum. Curabitur vel orci vitae odio congue facilisis eget eget diam.\n\nNam a arcu efficitur, ornare leo eu, euismod leo. Vestibulum porttitor varius leo, eget posuere felis congue vel. Sed sit amet erat quam. Mauris et ex sapien. Sed venenatis, felis sed eleifend vulputate, mauris libero pretium urna, non hendrerit urna quam vitae justo. Maecenas rhoncus lectus consectetur eros pretium feugiat.\n',
                    //   style: Theme.of(context).textTheme.caption,
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
        beginOffset: const Offset(0.0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
