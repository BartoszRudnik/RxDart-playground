import 'package:flutter/material.dart';
import 'package:rx_dart/dialogs/generic_dialog.dart';

Future<bool> deleteAccountDialog({
  required BuildContext context,
}) async =>
    await showGenericDialog(
      context: context,
      title: 'Delete account',
      content: 'Are you sure you want to delete account?',
      optionsBuilder: () => {
        'Yes': true,
        'No': false,
      },
    ).then(
      (value) => value ?? false,
    );
