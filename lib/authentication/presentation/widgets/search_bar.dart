import 'package:flutter/material.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';

class SearchBar extends StatelessWidget {
  final String? hint;
  final Function? onTap;
  final Color? color;
  final BoxShadow? boxShadow;

  const SearchBar({
    Key? key,
    this.hint,
    this.onTap,
    this.color,
    this.boxShadow,
  }) : super(key: key);

  get kMainColor => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
      decoration: BoxDecoration(
        boxShadow: [
          boxShadow ?? BoxShadow(color: kCardBackgroundColor),
        ],
        borderRadius: BorderRadius.circular(30.0),
        color: color ?? kCardBackgroundColor,
      ),
      child: TextField(
        readOnly: true,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: kMainColor,
        decoration: InputDecoration(
          icon: const ImageIcon(
            AssetImage('images/icons/ic_search.png'),
            color: Colors.black,
            size: 16,
          ),
          hintText: AppLocalizations.of(context)!.enterLocation,
          hintStyle: Theme.of(context).textTheme.headline6,
          border: InputBorder.none,
        ),
        onTap: onTap as void Function()?,
      ),
    );
  }
}
