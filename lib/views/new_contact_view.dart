import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rx_dart/helpers/if_debugging.dart';
import 'package:rx_dart/type_definitions.dart';

class NewContactView extends HookWidget {
  final CreateContactCallback createContactCallback;
  final GoBackCallback goBackCallback;

  const NewContactView({
    Key? key,
    required this.createContactCallback,
    required this.goBackCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstNameController = useTextEditingController(text: "test".ifDebugging);
    final lastNameController = useTextEditingController(text: "test123".ifDebugging);
    final phoneNumberController = useTextEditingController(text: '+47123123123'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            goBackCallback();
          },
          icon: const Icon(
            Icons.close,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter first name',
                ),
                keyboardType: TextInputType.name,
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter last name',
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter phone number',
                ),
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
              ),
              TextButton(
                onPressed: () {
                  final firstName = firstNameController.text;
                  final lastName = lastNameController.text;
                  final phoneNumber = phoneNumberController.text;

                  if (firstName.isNotEmpty && lastName.isNotEmpty && phoneNumber.isNotEmpty) {
                    createContactCallback(
                      firstName,
                      lastName,
                      phoneNumber,
                    );
                    goBackCallback();
                  }
                },
                child: const Text(
                  'Save Contact',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
