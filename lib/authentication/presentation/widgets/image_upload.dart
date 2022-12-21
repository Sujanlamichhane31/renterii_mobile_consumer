import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:renterii/authentication/business_logic/cubit/signup/signup_cubit.dart';

import '../../../Themes/colors.dart';

class ImageUpload extends StatefulWidget {
  final bool isUpdating;
  final String? imageUrl;
  final Function? onSetImage;
  final double size;

  const ImageUpload({
    Key? key,
    this.isUpdating = true,
    this.imageUrl,
    this.onSetImage,
    this.size = 48.0,
  }) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !widget.isUpdating
          ? null
          : () async {
              final ImagePicker _picker = ImagePicker();

              final XFile? image = await showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          'Pick your image',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                          child: ListBody(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.photo_album),
                                title: const Text('Pick from galley'),
                                onTap: () async {
                                  final XFile? image = await _picker.pickImage(
                                      source: ImageSource.gallery);
                                  Navigator.pop(context, image);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Camera'),
                                onTap: () async {
                                  final XFile? image = await _picker.pickImage(
                                      source: ImageSource.camera);
                                  Navigator.pop(context, image);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  });

              if (image == null) return;

              setState(() {
                this.image = File(image.path);
                widget.onSetImage!(this.image);
              });
            },
      child: Builder(builder: (context) {
        dynamic backgroundImage;
        if (widget.imageUrl != null && widget.imageUrl!.trim().isNotEmpty) {
          backgroundImage = NetworkImage(widget.imageUrl!);
        } else {
          backgroundImage = AssetImage("images/account/profile_icon.png");
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
      }),
    );
  }
}
