import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/Themes/style.dart';


class BottomBar extends StatelessWidget {
  final Function() onTap;
  final String? text;
  final Color? color;
  final Color? textColor;

  const BottomBar({
    Key? key,
    required this.onTap,
    required this.text,
    this.color,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(
            text!,
            style: textColor != null
                ? bottomBarTextStyle.copyWith(color: textColor)
                : bottomBarTextStyle,
          ),
        ),
        color: color ?? kMainColor,
        height: 60.0,
      ),
    );
  }
}
