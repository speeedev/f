import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class AuthNetwork {
  Dio _dio = Dio();

  AuthNetwork() {
    _dio = Dio(BaseOptions(baseUrl: "http://localhost:5433"));
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    String encryptedPassword = _encryptPassword(password);

    try {
      var response = await _dio.post("/login", data: {
        "username": username,
        "password": encryptedPassword,
      });

      if (response.statusCode == 200) {
        return {"success": true, "token": response.data["token"]};
      } else {
        return {"success": false, "error": "Server error"};
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        return {"success": false, "error": "Invalid username or password"};
      } else if (e.response != null) {
        return {
          "success": false,
          "error": "Server error: ${e.response!.statusMessage}"
        };
      } else {
        return {"success": false, "error": "An error occurred"};
      }
    }
  }

  Future<Map<String, dynamic>> checkToken(String token) async {
    try {
      var response = await _dio.get(
        "/secure",
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode == 200) {
        String serverUsername = response.data['user']['username'];
        return {"success": true, "username": serverUsername};
      } else {
        return {"success": false, "error": "Token is invalid"};
      }
    } on DioException catch (e) {
      return {"success": false, "error": "An error occurred"};
    }
  }

  String _encryptPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
