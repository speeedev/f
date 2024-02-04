import 'package:flutter/material.dart';
import 'package:flutter_jwt/screens/login/login_view.dart';
import 'package:flutter_jwt/screens/login/login_view_model.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => LoginViewModel(),
        child: const Scaffold(
          body: LoginForm(),
        ),
      ),
    );
  }
}