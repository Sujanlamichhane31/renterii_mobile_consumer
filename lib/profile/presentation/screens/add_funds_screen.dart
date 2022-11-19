import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/routes/routes.dart';

import '../../../orders/presentations/widgets/build-list.widget.dart';

class AddFundsScreen extends StatefulWidget {
  const AddFundsScreen({Key? key}) : super(key: key);

  @override
  _AddFundsState createState() => _AddFundsState();
}

class _AddFundsState extends State<AddFundsScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = '50.0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addMoney!,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(fontWeight: FontWeight.bold)),
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
      ),
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state.status == UserStatus.paymentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Your payment has been successfully done!'),
                backgroundColor: Colors.green,
              ),
            );
            context.router.pop();
          } else if (state.status == UserStatus.paymentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixStyle: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.black),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[200]!,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[200]!,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[200]!,
                    ),
                  ),
                  hintText: '50.0',
                  label: Text(
                    AppLocalizations.of(context)!
                        .enterAmountToAdd!
                        .toUpperCase(),
                  ),
                  hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 16.0,
              ),
              color: Theme.of(context).cardColor,
              child: Text(
                AppLocalizations.of(context)!.addVia!.toUpperCase(),
                style: Theme.of(context).textTheme.caption!.copyWith(
                      color: kDisabledColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.67,
                    ),
              ),
            ),
            BuildListTile(
              onTap: () {
                if (_controller.text != '') {
                  context.read<UserCubit>().addMoney(_controller.text);
                }
              },
              image: 'images/payment/payment_card.png',
              text: AppLocalizations.of(context)!.credit,
            ),
            BuildListTile(
              onTap: () => Navigator.pushNamed(context, PageRoutes.addMoney),
              image: 'images/payment/payment_card.png',
              text: AppLocalizations.of(context)!.debit,
            ),
            // BuildListTile(
            //   onTap: () => Navigator.pushNamed(context, PageRoutes.addMoney),
            //   image: 'images/payment/payment_paypal.png',
            //   text: AppLocalizations.of(context)!.paypal,
            // ),
            // BuildListTile(
            //   onTap: () => Navigator.pushNamed(context, PageRoutes.addMoney),
            //   image: 'images/payment/payment_payu.png',
            //   text: AppLocalizations.of(context)!.payU,
            // ),
            // BuildListTile(
            //   onTap: () => Navigator.pushNamed(context, PageRoutes.addMoney),
            //   image: 'images/payment/payment_stripe.png',
            //   text: AppLocalizations.of(context)!.stripe,
            // ),
            // Container(
            //   height: double.infinity,
            //   color: Theme.of(context).cardColor,
            // )
          ],
        ),
      ),
    );
  }
}
