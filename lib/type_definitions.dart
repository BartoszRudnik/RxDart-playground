import 'package:flutter/material.dart';
import 'package:rx_dart/models/contact.dart';

typedef LogoutCallback = VoidCallback;
typedef GoBackCallback = VoidCallback;
typedef DeleteAccountCallback = VoidCallback;
typedef GoToCreateContact = VoidCallback;

typedef LoginFunction = void Function(
  String email,
  String password,
);

typedef RegisterFunction = void Function(
  String email,
  String password,
);

typedef CreateContactCallback = void Function(
  String firstName,
  String lastName,
  String phoneNumber,
);

typedef DeleteContactCallback = void Function(
  Contact contact,
);
