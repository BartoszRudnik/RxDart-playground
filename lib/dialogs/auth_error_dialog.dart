import 'package:flutter/material.dart';
import 'package:rx_dart/bloc/auth_error.dart';
import 'package:rx_dart/dialogs/generic_dialog.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) async =>
    showGenericDialog(
      context: context,
      title: authError.dialogTitle,
      content: authError.dialogContent,
      optionsBuilder: () => {
        'OK': true,
      },
    );
