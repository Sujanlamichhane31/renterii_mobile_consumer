import 'package:flutter/material.dart';

import 'custom_search_bar.dart';

class CustomAppBar extends StatelessWidget {
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final Function? onTap;
  final String? hint;
  final PreferredSizeWidget? bottom;
  final Color? color;
  final BoxShadow? boxShadow;

  const CustomAppBar({
    Key? key,
    this.titleWidget,
    this.actions,
    this.leading,
    this.onTap,
    this.hint,
    this.bottom,
    this.color,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0.0,
      leading: leading,
      title: titleWidget,
      actions: actions,
      bottom: bottom ??
          PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: CustomSearchBar(
              boxShadow: boxShadow,
              color: color,
              hint: hint,
              onTap: onTap,
            ),
          ),
    );
  }
}
