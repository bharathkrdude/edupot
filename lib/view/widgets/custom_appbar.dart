import 'package:edupot/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  final Size preferredSize;

  CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  }) : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading, surfaceTintColor: white ,foregroundColor: white,
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
