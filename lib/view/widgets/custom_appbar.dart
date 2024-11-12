import 'package:edupot/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  
  @override
  final Size preferredSize;

  CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
  }) : preferredSize = Size.fromHeight(kToolbarHeight),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      backgroundColor: primaryButton,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
      title: Text(title),
      actions: actions,
    );
  }
}
