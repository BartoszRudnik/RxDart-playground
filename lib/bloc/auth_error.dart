import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> authErrorMapping = {
  'user-not-found': AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'operation-not-allowed': AuthErrorOperationNotAllowed(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'no-current-user': AuthErrorNoCurrentUser(),
};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogContent;

  const AuthError({
    required this.dialogContent,
    required this.dialogTitle,
  });

  factory AuthError.from(FirebaseAuthException exception) => authErrorMapping[exception.code.trim().toLowerCase()] ?? const AuthErrorUnknown();
}

@immutable
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
          dialogContent: 'Unknown authentication error',
          dialogTitle: 'Authentication Error',
        );
}

@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          dialogContent: 'No current user with that information was found',
          dialogTitle: 'No current user found',
        );
}

@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
          dialogContent: 'You need to logout and login again in order to perfrom this operation',
          dialogTitle: 'Requires recent login',
        );
}

@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed()
      : super(
          dialogContent: 'You cannot register using this metod at this moment',
          dialogTitle: 'Operation not allowed',
        );
}

@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          dialogContent: 'The given user was not found',
          dialogTitle: 'User not found',
        );
}

@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          dialogContent: 'Please choose stronger password consisting of more characters',
          dialogTitle: 'Weak password',
        );
}

@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          dialogContent: 'Please double check your email and try again',
          dialogTitle: 'Invalid email',
        );
}

@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          dialogContent: 'Given email is already in use by someone else',
          dialogTitle: 'Email already in use',
        );
}
