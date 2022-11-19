import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:renterii/authentication/data/data_providers/wallet_data_provider.dart';
import 'package:renterii/authentication/data/models/user.dart';

class WalletRepository {
  final WalletDataProvider _walletDataProvider;

  const WalletRepository({
    required WalletDataProvider walletDataProvider,
  }) : _walletDataProvider = walletDataProvider;

  String _calculateAmount(double amount) {
    final a = amount * 100;
    return a.toInt().toString();
  }

  Future<bool> makePayment({
    required double amount,
    required String currency,
    required CurrentUser user,
  }) async {
    try {
      final _paymentIntentData = await _walletDataProvider.createPaymentIntent(
          amount: _calculateAmount(amount));

      print(_paymentIntentData);

      if (_paymentIntentData['client_secret'] != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            billingDetails: BillingDetails(
              name: user.name,
              email: user.email,
              phone: user.phoneNumber,
            ),
            merchantDisplayName: 'Renterii',
            customerId: _paymentIntentData['customer'],
            paymentIntentClientSecret: _paymentIntentData['client_secret'],
            customerEphemeralKeySecret: _paymentIntentData['ephemeralKey'],
          ),
        );

        await Stripe.instance.presentPaymentSheet();
        return true;
      } else {
        throw 'An error occurred. Try again later!';
      }
    } catch (e, s) {
      print('exception:$e$s');

      String messageText = '';
      if (e is StripeException) {
        messageText =
            e.error.localizedMessage ?? 'An error occurred. Try again later!';
      } else {
        messageText = 'An error occurred. Try again later!';
      }

      throw messageText;
    }
  }

  Future<void> updateUserWalletBalance({
    required double amount,
    required double newWalletBalance,
    required String userId,
  }) async {
    _walletDataProvider.updateUserWalletBalance(
      amount: amount,
      newWalletBalance: newWalletBalance,
      userId: userId,
    );
  }
}
