import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:renterii/Themes/colors.dart';

import '../../../Themes/colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String? hint;
  final Function? onTap;
  final Color? color;
  final BoxShadow? boxShadow;

  const CustomSearchBar({
    Key? key,
    this.hint,
    this.onTap,
    this.color,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
      decoration: BoxDecoration(
        boxShadow: [
          boxShadow ?? BoxShadow(color: Theme.of(context).cardColor),
        ],
        borderRadius: BorderRadius.circular(30.0),
        color: color ?? Theme.of(context).cardColor,
      ),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        cursorColor: kMainColor,
        readOnly: true,
        decoration: InputDecoration(
          icon: ImageIcon(
            const AssetImage('images/icons/ic_search.png'),
            color: Theme.of(context).secondaryHeaderColor,
            size: 16,
          ),
          hintText: hint,
          hintStyle: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: kHintColor),
          border: InputBorder.none,
        ),
        onTap: onTap as void Function()?,
      ),
    );
  }
}
