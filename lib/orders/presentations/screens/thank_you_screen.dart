import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/routes/app_router.gr.dart';

import '../../../authentication/presentation/widgets/bottom_bar.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadedSlideAnimation(
        child: Column(
          children: <Widget>[
            const Spacer(),
            Expanded(
              flex: 3,
              child: FadedScaleAnimation(
                child: Image.asset(
                  'images/order_placed1.png',
                ),
                fadeDuration: const Duration(milliseconds: 800),
              ),
            ),
            const Spacer(),
            Text(
              AppLocalizations.of(context)!.placed!,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 23.3),
            ),
            Text(
              AppLocalizations.of(context)!.thanks!,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: kDisabledColor, fontSize: 18),
            ),
        const    Spacer(
                // flex: 2,
                ),
            BottomBar(
              text: AppLocalizations.of(context)!.orderText,
              onTap: () =>
                  context.router.popAndPush(const MyOrdersScreenRoute()),
            )
          ],
        ),
        beginOffset: const Offset(0.0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
