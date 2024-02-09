import 'package:flutter/material.dart';
import 'package:flutter_jwt/core/service/network/auth_network.dart';
import 'package:flutter_jwt/widgets/login/showUserInfoDialog.dart';
import 'package:flutter_jwt/widgets/showErrorDialog.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthNetwork _authNetwork = AuthNetwork();
  String token = "";
  String username = "";
  bool isLoading = false;

  Future<void> login(
      BuildContext context, String username, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      var result = await _authNetwork.login(username, password);

      if (result["success"]) {
        token = result["token"];
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkToken(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      var result = await _authNetwork.checkToken(token);

      if (result["success"]) {
        print(result);
        username = result["username"];
        showUserInfoDialog(context, username);
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
