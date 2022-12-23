import 'dart:io';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/authentication/business_logic/cubit/signup/signup_cubit.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/authentication/presentation/screens/location_screen.dart';
import 'package:renterii/authentication/presentation/screens/register_location_screen.dart';
import 'package:renterii/authentication/presentation/widgets/profile_image.dart';
import 'package:renterii/authentication/presentation/widgets/register_text_field.dart';
import 'package:renterii/utils/constant.dart';
import 'package:renterii/utils/extension.dart';
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
          context.router.replaceNamed('app');
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
  GlobalKey<FormState> registerKey = GlobalKey();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  double lat = 0.0;
  double long = 0.0;
  String? _choosenCategory;

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
    _addressController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final user = state.user;
        _nameController.text = user.name;
        _emailController.text = user.email ?? '';
        _phoneNumberController.text = user.phoneNumber ?? '';

        return Form(
          key: registerKey,
          child: Stack(
            children: <Widget>[
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: <Widget>[
                  Divider(
                    color: Theme.of(context).cardColor,
                    thickness: 8.0,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ProfileImage(
                    imageUrl: user.photoUrl,
                    onSetImage: (File image) {
                      context
                          .read<SignupCubit>()
                          .updateUserProfilePicture(image: image);
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  RegisterTextField(
                    onlyRead: false,
                    textEditingController: _nameController,
                    title:
                        AppLocalizations.of(context)!.fullName!.toUpperCase(),
                    hint: "Your full name",
                    img: 'images/icons/ic_name.png',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name should not be empty';
                      }
                      return null;
                    },
                  ),

                  RegisterTextField(
                    onlyRead: false,
                    textEditingController: _descriptionController,
                    title: "Description".toUpperCase(),
                    hint: 'your description',
                    img: 'images/icons/ic_phone.png',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Brief description is required';
                      } else {
                        return null;
                      }
                    },
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 22,
                            child: Image(
                              image: const AssetImage(
                                'images/icons/ic_phone.png',
                              ),
                              color: kMainColor,
                            ),
                          ),
                          const SizedBox(
                            width: 13,
                          ),
                          Text("Category".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12))
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 25),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  const SizedBox.shrink(),
                                  DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        isDense: true,
                                        prefixStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                color: Colors.black,
                                                fontSize: 12),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[200]!),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[200]!),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[200]!),
                                        ),
                                      ),
                                      hint: const Text("Select Category"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              color: Colors.black,
                                              fontSize: 14),
                                      value: _choosenCategory,
                                      validator: ((value) {
                                        if (_choosenCategory == null) {
                                          return 'Please select category';
                                        } else {
                                          return null;
                                        }
                                      }),
                                      items: profileCategory.map((profile) {
                                        return DropdownMenuItem<String>(
                                          child: Text(profile.name),
                                          value: profile.categoryId,
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        _choosenCategory = value;
                                      }),
                                  const SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  //name textField
                  //email textField
                  RegisterTextField(
                    onlyRead: false,
                    textEditingController: _emailController,
                    title: AppLocalizations.of(context)!
                        .emailAddress!
                        .toUpperCase(),
                    hint: 'abc@gmail.com',
                    img: 'images/icons/ic_phone.png',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email Address is required';
                      } else if (!value.isValidEmail()) {
                        return 'Email address is not valid';
                      } else {
                        return null;
                      }
                    },
                  ),

                  //phone textField
                  RegisterTextField(
                    onlyRead: false,
                    textEditingController: _phoneNumberController,
                    title: AppLocalizations.of(context)!
                        .mobileNumber!
                        .toUpperCase(),
                    hint: '+1 987 654 3210',
                    img: 'images/icons/ic_phone.png',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Number is required';
                      } else {
                        return null;
                      }
                    },
                  ),

                  RegisterTextField(
                    textEditingController: _addressController,
                    title: "Address".toUpperCase(),
                    hint: "Select your address",
                    onlyRead: true,
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RegisterLocationScreen(
                                    textEditingController: _addressController,
                                  )));
                      lat = result["lat"];
                      long = result["long"];
                    },
                    img: 'images/location.png',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Set location';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  )
                ],
              ),
              //continue button bar
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomBar(
                    text: AppLocalizations.of(context)!.continueText,
                    onTap: () {
                      if (registerKey.currentState!.validate()) {
                        registerKey.currentState!.save();
                        context.read<SignupCubit>().updateUserProfile(
                              name: _nameController.text,
                              email: _emailController.text,
                              phoneNumber: _phoneNumberController.text,
                              userId: context.read<UserCubit>().state.user.id,
                              photoUrl: user.photoUrl,
                              address: _addressController.text,
                              description: _descriptionController.text,
                              latitude: lat,
                              longitude: long,
                              category: _choosenCategory,
                            );
                      }
                    }),
              )
            ],
          ),
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
