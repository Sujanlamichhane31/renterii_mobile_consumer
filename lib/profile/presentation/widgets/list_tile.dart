import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';

class BuildListTile extends StatelessWidget {
  final String? image;
  final String? text;
  final Function? onTap;
  final bool small;

  const BuildListTile({Key? key, this.image, this.text, this.onTap, this.small = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
      leading: FadedScaleAnimation(
        child: Image.asset(
          image!,
          height: small ? 26 : 36,
        ),
        fadeDuration: const Duration(milliseconds: 200),
      ),
      title: Text(
        text!,
        style: Theme.of(context).textTheme.headline4!.copyWith(
            fontWeight: FontWeight.bold, letterSpacing: 0.07, fontSize: 17),
      ),
      onTap: onTap as void Function()?,
    );
  }
}