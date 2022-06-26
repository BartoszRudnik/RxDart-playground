import 'package:flutter/material.dart';
import 'package:rx_dart/dialogs/delete_account_dialog.dart';
import 'package:rx_dart/dialogs/logout_dialog.dart';
import 'package:rx_dart/type_definitions.dart';

enum MenuAction {
  logout,
  deleteAccount,
}

class MainPopupMenuButton extends StatelessWidget {
  final LogoutCallback logoutCallback;
  final DeleteAccountCallback deleteAccountCallback;

  const MainPopupMenuButton({
    Key? key,
    required this.deleteAccountCallback,
    required this.logoutCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogout = await logoutDialog(context: context);

            if (shouldLogout) {
              logoutCallback();
            }
            break;
          case MenuAction.deleteAccount:
            final shouldDeleteAccount = await deleteAccountDialog(context: context);

            if (shouldDeleteAccount) {
              deleteAccountCallback();
            }
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<MenuAction>(
          child: Text("Logout"),
          value: MenuAction.logout,
        ),
        const PopupMenuItem<MenuAction>(
          child: Text("Delete account"),
          value: MenuAction.deleteAccount,
        ),
      ],
    );
  }
}
