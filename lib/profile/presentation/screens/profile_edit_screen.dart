import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/authentication/business_logic/cubit/signup/signup_cubit.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/authentication/presentation/screens/location_screen.dart';
import 'package:renterii/authentication/presentation/screens/register_location_screen.dart';
import 'package:renterii/authentication/presentation/widgets/image_upload.dart';
import 'package:renterii/authentication/presentation/widgets/profile_image.dart';
import 'package:renterii/authentication/presentation/widgets/register_text_field.dart';
import 'package:renterii/rentals/presentation/screens/shops_map_screen.dart';
import 'package:renterii/routes/app_router.gr.dart';
import 'package:renterii/utils/constant.dart';
import 'package:renterii/utils/extension.dart';

import '../../../Locale/locales.dart';
import '../../../Themes/colors.dart';
import '../../../rentals/presentation/widgets/bottom_bar.dart';
import '../widgets/text_field.dart';

class ProfileEditPage extends StatefulWidget implements AutoRouteWrapper {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    // TODO: Get repository from provider
    return BlocProvider<SignupCubit>.value(
      value: context.read<SignupCubit>(),
      child: this,
    );
  }

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _descriptionEditingController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  double lat = 0.0;
  double long = 0.0;
  String? _choosenCategory;
  GlobalKey<FormState> profileEditKey = GlobalKey();

  String imageUrl = '';
  File? image;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _descriptionEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
      ),
      body: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          log(state.toString());
          if (state is SignupInfosSuccess) {
            context.router.pop();
          } else if (state is UpdatingLocation) {
            context.router.push(
              LocationScreenRoute(),
            );
          } else if (state is SignupInfosFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                content: Text('An error occurred while updating profile !'),
              ),
            );
          }
        },
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            final user = state.user;
            lat = user.latitude ?? 0.0;
            long = user.longitude ?? 0.0;
            _nameController.text = user.name ?? '';
            _emailController.text = user.email ?? '';
            _phoneNumberController.text = user.phoneNumber ?? '';
            _addressController.text = user.address ?? '';
            _choosenCategory = user.category ?? '-1';
            _descriptionEditingController.text = user.description ?? '';
            return Form(
              key: profileEditKey,
              child: Stack(
                children: <Widget>[
                  ListView(
                    padding: const EdgeInsets.only(bottom: 70, left: 5),
                    children: <Widget>[
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 8.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'PROFILE IMAGE',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.67,
                                  color: kHintColor),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),

                      ProfileImage(
                          imageUrl: user.photoUrl,
                          onSetImage: (File image) {
                            context
                                .read<SignupCubit>()
                                .updateUserProfilePicture(image: image);
                          }),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SmallTextFormField(
                          label: AppLocalizations.of(context)!
                              .fullName!
                              .toUpperCase(),
                          title: "Enter name",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Shop Name is required';
                            } else {
                              return null;
                            }
                          },
                          textEditingController: _nameController,
                          controller: _nameController,
                        ),
                      ),
                      // inputField(
                      //   AppLocalizations.of(context)!
                      //       .fullName!
                      //       .toUpperCase(),
                      //   '',
                      //   'images/icons/ic_name.png',
                      //   _nameController,
                      // ),
                      //name textField
                      //email textField

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SmallTextFormField(
                          label: "Description".toUpperCase(),
                          title: "Enter decription",
                          icon: null,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Brief Description is required';
                            } else {
                              return null;
                            }
                          },
                          controller: _descriptionEditingController,
                          textEditingController: _descriptionEditingController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Category",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                            DropdownButtonFormField(
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          color: Colors.black, fontSize: 12),
                                  border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[200]!),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[200]!),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[200]!),
                                  ),
                                ),
                                hint: const Text("Select Category"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        color: Colors.grey[200]!, fontSize: 14),
                                value: _choosenCategory,
                                dropdownColor: Colors.grey[400]!,
                                validator: ((value) {
                                  if (_choosenCategory == null &&
                                      _choosenCategory == "-1") {
                                    return 'Please select category';
                                  } else {
                                    return null;
                                  }
                                }),
                                items: profileCategory.map((CategoryId) {
                                  return DropdownMenuItem<String>(
                                    value: CategoryId.categoryId,
                                    child: Text(CategoryId.name),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SmallTextFormField(
                            // AppLocalizations.of(context)!.fullName!.toUpperCase(),
                            label: "Email",
                            title: "Enter email",
                            icon: null,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email should not be empty';
                              } else if (!value.isValidEmail()) {
                                return 'Email address is not valid';
                              } else {
                                return null;
                              }
                            },
                            textEditingController: _emailController,
                            keyBoardType: TextInputType.emailAddress,
                            controller: _emailController),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SmallTextFormField(
                            // AppLocalizations.of(context)!.fullName!.toUpperCase(),
                            label: "Phone",
                            title: "Enter Phone",
                            icon: null,
                            initial: "Food Junction",
                            keyBoardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Number is required';
                              } else {
                                return null;
                              }
                            },
                            textEditingController: _phoneNumberController,
                            controller: _phoneNumberController),
                      ),
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 8.0,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .address!
                                  .toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.67,
                                      color: kHintColor),
                            ),
                          ),
                          //address textField
                          RegisterTextField(
                            textEditingController: _addressController,
                            title: "",
                            hint: "Select your address",
                            onlyRead: true,
                            onTap: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => RegisterLocationScreen(
                                            textEditingController:
                                                _addressController,
                                            lat: user.latitude,
                                            long: user.longitude,
                                          )));
                              lat = result["lat"];
                              long = result["long"];
                            },
                            img: '',
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

                      // ListTile(
                      //   contentPadding: const EdgeInsets.only(left: 0.0),
                      //   leading: const Icon(Icons.location_pin),
                      //   title: Text(
                      //     user.address ?? 'Address not set',
                      //   ),
                      //   subtitle: Text(
                      //     user.addressType?.toLowerCase() ?? '',
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .bodySmall
                      //         ?.copyWith(color: Colors.grey),
                      //   ),
                      //   trailing: TextButton(
                      //     onPressed: () {
                      //       final user = state.user;

                      //       context
                      //           .read<SignupCubit>()
                      //           .startUpdatingUserLocation(
                      //             address: user.address ?? '',
                      //             addressType: user.addressType ?? '',
                      //             latitude: user.latitude!,
                      //             longitude: user.longitude!,
                      //             userId: user.id,
                      //           );
                      //     },
                      //     child: const Text('Change'),
                      //   ),
                      // ),

                      // Padding(
                      //   padding: const EdgeInsets.only(left: 16.0, bottom: 80),
                      //   child: Text(
                      //     AppLocalizations.of(context)!.verificationText!,
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .headline6!
                      //         .copyWith(fontSize: 12.8),
                      //   ),
                      // ),
                    ],
                  ),
                  //continue button bar
                  Builder(builder: (context) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: BottomBar(
                          text: 'Submit',
                          onTap: () {
                            if (profileEditKey.currentState!.validate()) {
                              profileEditKey.currentState!.save();
                              context.read<SignupCubit>().updateUserProfile(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    phoneNumber: _phoneNumberController.text,
                                    userId:
                                        context.read<UserCubit>().state.user.id,
                                    photoUrl: user.photoUrl,
                                    address: _addressController.text,
                                    description:
                                        _descriptionEditingController.text,
                                    latitude: lat,
                                    longitude: long,
                                    category: _choosenCategory,
                                  );
                              if (_phoneNumberController.text != '') {
                                // TODO: Verify phoneNumber
                                // TODO: Navigate to verification page
                              }
                            }
                          }),
                    );
                  })
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Column inputField(
    String title,
    String hint,
    String img,
    TextEditingController controller,
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
                label: '',
                title: '',
                controller: controller,
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
