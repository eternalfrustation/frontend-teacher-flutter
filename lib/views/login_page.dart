import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Column(children: [
        TextFormField(
          controller: usernameController,
        ),
        TextFormField(
          controller: passwordController,
        ),
        TextButton(
          onPressed: () {
            Store.login(Cred(
                    username: usernameController.text,
                    password: passwordController.text))
                .then((_) {
              if (context.mounted) {
                context.go("/dashboard");
              }
            });
          },
          child: const Text("Login"),
        )
      ]);
}
