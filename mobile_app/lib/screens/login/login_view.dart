import 'package:flutter/material.dart';
import 'package:flutter_jwt/screens/login/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Column(
      children: [
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(labelText: "Username"),
        ),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(labelText: "Password"),
          obscureText: true,
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: loginViewModel.isLoading
              ? null
              : () async {
                  await loginViewModel.login(
                    context,
                    usernameController.text,
                    passwordController.text,
                  );
                },
          child: Text(loginViewModel.isLoading ? "Loading..." : "Login"),
        ),
        const SizedBox(height: 50),
        Text("Token: ${loginViewModel.token}"),
        ElevatedButton(
          onPressed: loginViewModel.isLoading
              ? null
              : () async {
                  await loginViewModel.checkToken(context);
                },
          child: Text(loginViewModel.isLoading ? "Loading..." : "Check Token"),
        ),
      ],
    );
  }
}
