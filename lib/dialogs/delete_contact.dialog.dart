import 'package:flutter/material.dart';
import 'package:rx_dart/dialogs/generic_dialog.dart';

Future<bool> deleteContactDialog({
  required BuildContext context,
}) async =>
    await showGenericDialog(
      context: context,
      title: 'Delete contact',
      content: 'Are you sure you want to delete contact?',
      optionsBuilder: () => {
        'Yes': true,
        'No': false,
      },
    ).then(
      (value) => value ?? false,
    );
