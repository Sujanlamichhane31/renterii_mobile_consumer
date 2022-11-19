import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/authentication/business_logic/cubit/signup/signup_cubit.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/routes/app_router.gr.dart';

import '../widgets/bottom_bar.dart';
import '../widgets/image_upload.dart';
import '../widgets/text_field.dart';

class RegisterScreen extends StatelessWidget {
  final String? phoneNumber;

  const RegisterScreen({Key? key, this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupInfosSuccess) {
          context.router.replace(const LocationScreenRoute());
        } else if (state is SignupInfosFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: Text('An error occurred!'),
            ),
          );
        }
      },
      child: Scaffold(
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
          title: Text(
            AppLocalizations.of(context)!.register!,
            style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 20),
          ),
        ),

        //this column contains 3 textFields and a bottom bar
        body: FadedSlideAnimation(
          child: const RegisterForm(),
          beginOffset: const Offset(0.0, 0.3),
          endOffset: const Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  final String? phoneNumber;

  const RegisterForm({
    Key? key,
    this.phoneNumber,
  }) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  // RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    // _registerBloc = BlocProvider.of<RegisterBloc>(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final user = state.user;

        _nameController.text = user.name ?? '';
        _emailController.text = user.email ?? '';
        _phoneNumberController.text = user.phoneNumber ?? '';

        return Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Divider(
                      color: Theme.of(context).cardColor,
                      thickness: 8.0,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ImageUpload(
                      imageUrl: user.photoUrl,
                      onSetImage: (File image) {
                        context
                            .read<SignupCubit>()
                            .updateUserProfilePicture(image: image!);
                      },
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    inputField(
                      AppLocalizations.of(context)!.fullName!.toUpperCase(),
                      '',
                      'images/icons/ic_name.png',
                      _nameController,
                      TextInputType.name,
                    ),
                    //name textField
                    //email textField
                    inputField(
                      //controller: _emailController,
                      AppLocalizations.of(context)!.emailAddress!.toUpperCase(),
                      '',
                      'images/icons/ic_mail.png',
                      _emailController,
                      TextInputType.emailAddress,
                    ),

                    //phone textField
                    inputField(
                      AppLocalizations.of(context)!.mobileNumber!.toUpperCase(),
                      widget.phoneNumber ?? '',
                      'images/icons/ic_phone.png',
                      _phoneNumberController,
                      TextInputType.phone,
                    ),
                  ],
                ),
              ),
            ),
            //continue button bar
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomBar(
                  text: AppLocalizations.of(context)!.continueText,
                  onTap: () {
                    if (_nameController.text == '') {
                      return;
                    }

                    context.read<SignupCubit>().updateUserProfile(
                          name: _nameController.text,
                          email: _emailController.text,
                          phoneNumber: _phoneNumberController.text,
                          userId: context.read<UserCubit>().state.user.id,
                        );
                    if (widget.phoneNumber == null) {
                      // TODO: Verify phoneNumber
                      // TODO: Navigate to verification page
                    }
                  }),
            )
          ],
        );
      },
    );
  }

  Column inputField(
    String title,
    String hint,
    String img,
    TextEditingController controller,
    TextInputType keyboardType,
  ) {
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
              SmallTextFormField(
                controller: controller,
                label: null,
                title: hint,
                keyboardType: keyboardType,
              ),
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
