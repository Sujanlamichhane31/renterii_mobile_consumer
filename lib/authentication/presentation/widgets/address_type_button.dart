import 'package:flutter/material.dart';
import 'package:renterii/Themes/colors.dart';

class AddressTypeButton extends StatelessWidget {
  final String? label;
  final String? image;
  final Function? onPressed;
  final bool? isSelected;
  final Color selectedColor = Colors.white;
  final Color unSelectedColor = Colors.black;

  const AddressTypeButton({
    Key? key,
    this.label,
    this.image,
    this.onPressed,
    this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        backgroundColor: isSelected! ? kMainColor : Theme.of(context).cardColor,
      ),
      onPressed: onPressed as void Function()?,
      icon: Image.asset(
        image!,
        height: 18.0,
        color: isSelected! ? selectedColor : unSelectedColor,
      ),
      label: Text(
        label!,
        style: TextStyle(
          color: isSelected! ? selectedColor : unSelectedColor,
        ),
      ),
    );
  }
}
