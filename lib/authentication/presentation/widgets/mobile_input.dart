import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';

class MobileInput extends StatefulWidget {
  const MobileInput({Key? key}) : super(key: key);

  @override
  _MobileInputState createState() => _MobileInputState();
}

class _MobileInputState extends State<MobileInput> {
  final PhoneController _controller = PhoneController(null);
  String? isoCode;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6.0),
      decoration: BoxDecoration(color: kMainColor.withOpacity(0.5)),
      // decoration: const BoxDecoration(color: Color(0xffF9F9FD)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: PhoneFormField(
              controller: _controller,
              shouldFormat: true,
              defaultCountry: IsoCode.CA,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.mobileText,
                border: InputBorder.none,
              ),
              validator: PhoneValidator
                  .validMobile(), // default PhoneValidator.valid()
              isCountryChipPersistent: false, // default
              isCountrySelectionEnabled: true, // default
              countrySelectorNavigator:
                  const CountrySelectorNavigator.modalBottomSheet(),
              showFlagInInput: true, // default
              flagSize: 16, // default
              autofillHints: const [AutofillHints.telephoneNumber],
              enabled: true, // default
              autofocus: false, // default
              // onSaved: (PhoneNumber p) => print('saved $p'), // default null
              // onChanged: (PhoneNumber p) => print('saved $p'), // default null
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.continueText!,
                style: Theme.of(context).textTheme.button,
              ),
            ),
            onPressed: () {
              if (_controller.value == null) {
                return;
              }

              context.read<UserCubit>().loginWithPhoneNumber(
                  phoneNumber: _controller.value!.international);
            },
          ),
        ],
      ),
    );
  }
}
