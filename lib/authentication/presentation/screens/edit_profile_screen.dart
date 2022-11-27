import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/routes/app_router.gr.dart';

import '../../../Locale/locales.dart';
import '../../../Themes/colors.dart';
import '../../../rentals/presentation/widgets/bottom_bar.dart';
import '../../business_logic/cubit/signup/signup_cubit.dart';
import '../../business_logic/cubit/user/user_cubit.dart';
import '../widgets/image_upload.dart';
import '../widgets/text_field.dart';

class EditProfileScreen extends StatefulWidget implements AutoRouteWrapper {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    // TODO: Get repository from provider
    return BlocProvider<SignupCubit>.value(
      value: context.read<SignupCubit>(),
      child: this,
    );
  }

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  File? image;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
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

            _nameController.text = user.name;
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
                                  .updateUserProfilePicture(image: image);
                            }),
                        const SizedBox(
                          height: 16.0,
                        ),
                        inputField(
                          AppLocalizations.of(context)!.fullName!.toUpperCase(),
                          '',
                          'images/icons/ic_name.png',
                          _nameController,
                        ),
                        //name textField
                        //email textField
                        inputField(
                          //controller: _emailController,
                          AppLocalizations.of(context)!
                              .emailAddress!
                              .toUpperCase(),
                          '',
                          'images/icons/ic_mail.png',
                          _emailController,
                        ),

                        //phone textField
                        inputField(
                          AppLocalizations.of(context)!
                              .mobileNumber!
                              .toUpperCase(),
                          '',
                          'images/icons/ic_phone.png',
                          _phoneNumberController,
                        ),

                        ListTile(
                          contentPadding: const EdgeInsets.only(left: 0.0),
                          leading: const Icon(Icons.location_pin),
                          title: Text(
                            user.address ?? 'Address not set',
                          ),
                          subtitle: Text(
                            user.addressType?.toLowerCase() ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey),
                          ),
                          trailing: TextButton(
                            onPressed: () {
                              final user = state.user;

                              context
                                  .read<SignupCubit>()
                                  .startUpdatingUserLocation(
                                    address: user.address ?? '',
                                    addressType: user.addressType ?? '',
                                    latitude: user.latitude!,
                                    longitude: user.longitude!,
                                    userId: user.id,
                                  );
                            },
                            child: const Text('Change'),
                          ),
                        ),

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
                  ),
                ),
                //continue button bar
                Builder(builder: (context) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: BottomBar(
                        text: 'Submit',
                        onTap: () {
                          context.read<SignupCubit>().updateUserProfile(
                                name: _nameController.text,
                                email: _emailController.text,
                                phoneNumber: _phoneNumberController.text,
                                userId: context.read<UserCubit>().state.user.id,
                              );
                          if (_phoneNumberController.text != '') {
                            // TODO: Verify phoneNumber
                            // TODO: Navigate to verification page
                          }
                        }),
                  );
                })
              ],
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
