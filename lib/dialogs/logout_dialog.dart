import 'package:flutter/material.dart';
import 'package:rx_dart/dialogs/generic_dialog.dart';

Future<bool> logoutDialog({
  required BuildContext context,
}) async =>
    await showGenericDialog(
      context: context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      optionsBuilder: () => {
        'Yes': true,
        'No': false,
      },
    ).then(
      (value) => value ?? false,
    );
