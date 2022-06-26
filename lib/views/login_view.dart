import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rx_dart/helpers/if_debugging.dart';
import 'package:rx_dart/type_definitions.dart';

class LoginView extends HookWidget {
  final VoidCallback goToRegisterView;
  final LoginFunction loginFunction;

  const LoginView({
    Key? key,
    required this.goToRegisterView,
    required this.loginFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text: 'test@test.com'.ifDebugging);
    final passwordController = useTextEditingController(text: 'test1234'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
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
                loginFunction(emailController.text, passwordController.text);
              },
              child: const Text(
                "Login",
              ),
            ),
            TextButton(
              onPressed: () {
                goToRegisterView();
              },
              child: const Text('No account? Go to register screen,'),
            ),
          ],
        ),
      ),
    );
  }
}
