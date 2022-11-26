import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/authentication/business_logic/cubit/signup/signup_cubit.dart';

import '../../../Themes/colors.dart';

class ProfileImage extends StatefulWidget {
  final bool isUpdating;
  final String? imageUrl;
  final Function? onSetImage;
  final double size;

  const ProfileImage({
    Key? key,
    this.isUpdating = true,
    this.imageUrl,
    this.onSetImage,
    this.size = 48.0,
  }) : super(key: key);

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      dynamic backgroundImage;
      if (widget.imageUrl != null && widget.imageUrl!.trim().isNotEmpty) {
        backgroundImage = NetworkImage(widget.imageUrl!);
      } else {
        backgroundImage = Image.asset("images/account/profile_icon.png");
        
      }

      if (image != null) {
        backgroundImage = FileImage(image!);
      }

      return CircleAvatar(
        radius: widget.size,
        backgroundColor: kMainColor,
        backgroundImage: backgroundImage,
        child: BlocBuilder<SignupCubit, SignupState>(
          builder: (ctx, state) {
            if (!widget.isUpdating) {
              return Container();
            }

            if (state is ImageUploadLoading) {
              return const CircularProgressIndicator();
            }

            return const Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 36.0,
            );
          },
        ),
      );
    });
  }
}
