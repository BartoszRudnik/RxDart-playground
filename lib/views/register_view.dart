import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rx_dart/helpers/if_debugging.dart';
import 'package:rx_dart/type_definitions.dart';

class RegisterView extends HookWidget {
  final VoidCallback goToLoginView;
  final RegisterFunction registerFunction;

  const RegisterView({
    Key? key,
    required this.goToLoginView,
    required this.registerFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text: 'test@test.com'.ifDebugging);
    final passwordController = useTextEditingController(text: 'test1234'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
            ),
            TextButton(
              onPressed: () {
                registerFunction(emailController.text, passwordController.text);
              },
              child: const Text(
                "Register",
              ),
            ),
            TextButton(
              onPressed: () {
                goToLoginView();
              },
              child: const Text('Already have account? Go to login screen'),
            ),
          ],
        ),
      ),
    );
  }
}
