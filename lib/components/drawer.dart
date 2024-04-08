// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:social_media_app/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  void Function()? onProfileTap;
  void Function()? onSignOutTap;
  MyDrawer({super.key, required this.onProfileTap, required this.onSignOutTap,});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 65,
                ),
              ),
              MyListTile(
                icon: Icons.home,
                text: 'H O M E',
                onTap: () => Navigator.pop(context),
              ),
              MyListTile(
                icon: Icons.person,
                text: 'P R O F I L E',
                onTap: onProfileTap,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              icon: Icons.logout_rounded,
              text: 'L O G O U T',
              onTap: onSignOutTap,
            ),
          ),
        ],
      ),
    );
  }
}
