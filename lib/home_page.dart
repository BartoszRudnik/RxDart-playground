import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rx_dart/bloc/app_bloc.dart';
import 'package:rx_dart/bloc/auth_error.dart';
import 'package:rx_dart/dialogs/auth_error_dialog.dart';
import 'package:rx_dart/loading/loading_screen.dart';
import 'package:rx_dart/views/contacts_list_view.dart';
import 'package:rx_dart/views/current_view.dart';
import 'package:rx_dart/views/login_view.dart';
import 'package:rx_dart/views/new_contact_view.dart';
import 'package:rx_dart/views/register_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppBloc appBloc;
  StreamSubscription<AuthError?>? _authErrorsSub;
  StreamSubscription<bool>? _isLoadingSub;

  @override
  void initState() {
    super.initState();

    appBloc = AppBloc();
  }

  @override
  void dispose() {
    appBloc.dispose();

    _authErrorsSub?.cancel();
    _isLoadingSub?.cancel();

    super.dispose();
  }

  void handleAuthError(BuildContext context) async {
    await _authErrorsSub?.cancel();

    _authErrorsSub = appBloc.authError.listen((authError) {
      if (authError == null) {
        return;
      } else {
        showAuthError(
          authError: authError,
          context: context,
        );
      }
    });
  }

  void setupLoadingScreen(BuildContext context) async {
    await _isLoadingSub?.cancel();

    _isLoadingSub = appBloc.isLoading.listen(
      (isLoading) {
        if (isLoading) {
          LoadingScreen.instance().show(context: context, text: 'Loading...');
        } else {
          LoadingScreen.instance().hide();
        }
      },
    );
  }

  Widget getHomePage() {
    return StreamBuilder<CurrentView>(
      stream: appBloc.currentView,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            final currentView = snapshot.requireData;

            switch (currentView) {
              case CurrentView.login:
                return LoginView(
                  goToRegisterView: appBloc.goToRegisterView,
                  loginFunction: appBloc.login,
                );
              case CurrentView.register:
                return RegisterView(
                  goToLoginView: appBloc.goToLoginView,
                  registerFunction: appBloc.register,
                );
              case CurrentView.contactList:
                return ContactsListView(
                  contact: appBloc.contacts,
                  goToCreateContact: appBloc.goToCreateContactView,
                  deleteAccountCallback: appBloc.deleteAccount,
                  logoutCallback: appBloc.logout,
                  deleteContactCallback: appBloc.deleteContact,
                );
              case CurrentView.createContact:
                return NewContactView(
                  createContactCallback: appBloc.createContact,
                  goBackCallback: appBloc.goToContactListView,
                );
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    handleAuthError(context);
    setupLoadingScreen(context);

    return getHomePage();
  }
}
