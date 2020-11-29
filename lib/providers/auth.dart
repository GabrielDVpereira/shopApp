import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  static final _signUp_url = DotEnv().env['SIGNUP_URL'];
  static final _signIn_url = DotEnv().env['SIGNIN_URL'];

  Future<void> signUp(String email, String password) async {
    final response = await http.post(
      _signUp_url,
      body: json.encode(
        {
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
      ),
    );

    print(json.decode(response.body));

    return Future.value();
  }

  Future<void> signIn(String email, String password) async {
    final response = await http.post(
      _signIn_url,
      body: json.encode(
        {
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
      ),
    );

    print(json.decode(response.body));

    return Future.value();
  }
}
