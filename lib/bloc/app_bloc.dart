import 'dart:async';

import 'package:flutter/foundation.dart' show immutable;
import 'package:rx_dart/bloc/auth_bloc/auth_bloc.dart';
import 'package:rx_dart/bloc/auth_error.dart';
import 'package:rx_dart/bloc/contacts_bloc/contacts_bloc.dart';
import 'package:rx_dart/bloc/views_bloc/views_bloc.dart';
import 'package:rx_dart/models/contact.dart';
import 'package:rx_dart/views/current_view.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class AppBloc {
  final AuthBloc _authBloc;
  final ContactsBloc _contactsBloc;
  final ViewsBloc _viewsBloc;

  final Stream<CurrentView> currentView;
  final Stream<bool> isLoading;
  final Stream<AuthError?> authError;
  final StreamSubscription<String?> _userIdChanges;

  const AppBloc._({
    required AuthBloc authBloc,
    required ContactsBloc contactsBloc,
    required ViewsBloc viewsBloc,
    required this.currentView,
    required this.isLoading,
    required this.authError,
    required StreamSubscription<String?> userIdChanges,
  })  : _authBloc = authBloc,
        _contactsBloc = contactsBloc,
        _userIdChanges = userIdChanges,
        _viewsBloc = viewsBloc;

  factory AppBloc() {
    final authBloc = AuthBloc();
    final contactsBloc = ContactsBloc();
    final viewsBloc = ViewsBloc();

    final userIdChanges = authBloc.userId.listen(
      (String? userId) {
        contactsBloc.userId.add(
          userId,
        );
      },
    );

    final Stream<CurrentView> currentViewBasedOnAuthStatus = authBloc.authStatus.map<CurrentView>(
      (authStatus) {
        if (authStatus is AuthStatusLoggedIn) {
          return CurrentView.contactList;
        } else {
          return CurrentView.login;
        }
      },
    );

    final Stream<CurrentView> currentView = Rx.merge(
      [
        currentViewBasedOnAuthStatus,
        viewsBloc.currentView,
      ],
    );

    return AppBloc._(
      authBloc: authBloc,
      contactsBloc: contactsBloc,
      viewsBloc: viewsBloc,
      currentView: currentView,
      isLoading: authBloc.isLoading.asBroadcastStream(),
      authError: authBloc.authError.asBroadcastStream(),
      userIdChanges: userIdChanges,
    );
  }

  void dispose() {
    _authBloc.dispose();
    _viewsBloc.dispose();
    _contactsBloc.dispose();
    _userIdChanges.cancel();
  }

  void deleteContact(Contact contact) {
    _contactsBloc.deleteContact.add(
      contact,
    );
  }

  void createContact(
    String firstName,
    String lastName,
    String phoneNumber,
  ) {
    _contactsBloc.createContact.add(
      Contact.withoutId(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      ),
    );
  }

  void logout() {
    _authBloc.logout.add(null);
  }

  Stream<Iterable<Contact>> get contacts => _contactsBloc.contacts;

  void register(String email, String password) {
    _authBloc.register.add(
      RegisterCommand(
        email: email,
        password: password,
      ),
    );
  }

  void login(String email, String password) {
    _authBloc.login.add(
      LogInCommand(
        email: email,
        password: password,
      ),
    );
  }

  void deleteAccount() {
    _contactsBloc.deleteAllContacts.add(null);
    _authBloc.deleteAccount.add(null);
  }

  void goToContactListView() => _viewsBloc.goToView.add(
        CurrentView.contactList,
      );

  void goToCreateContactView() => _viewsBloc.goToView.add(
        CurrentView.createContact,
      );

  void goToRegisterView() => _viewsBloc.goToView.add(
        CurrentView.register,
      );

  void goToLoginView() => _viewsBloc.goToView.add(
        CurrentView.login,
      );
}
