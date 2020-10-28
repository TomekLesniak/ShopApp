import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../models/api_key.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(String email, String password, String url) async {
    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));

    print(response.body);
  }

  Future<void> signup(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${Api.key}';

    return _authenticate(email, password, url);
  }

  Future<void> signIn(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${Api.key}';
    return _authenticate(email, password, url);
  }
}
