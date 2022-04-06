import 'package:flutter/material.dart';
import 'package:getogether/utils/constants.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text("GeTogether"),
      backgroundColor: Palette.primaryColor,
      elevation: 0.0,
      /*leading: IconButton(
        icon: const Icon(Icons.menu),
        iconSize: 28.0,
        onPressed: () {},
      ),*/
      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.notifications_none),
            iconSize: 28.0,
            onPressed: () {})
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
