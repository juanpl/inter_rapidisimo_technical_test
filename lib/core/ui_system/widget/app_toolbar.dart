import 'package:flutter/material.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/colors/application_colors.dart';

class AppToolbar extends StatelessWidget implements PreferredSizeWidget {
  const AppToolbar({super.key, this.leading, this.actions});

  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ApplicationColors.fourthBrandColor,
      leading: leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
