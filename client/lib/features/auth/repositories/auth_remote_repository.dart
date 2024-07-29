import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        // Uri.parse('http://127.0.0.1:8000/auth/signup'), //ios emmulator localhost api
        Uri.parse(
            'http://10.0.2.2:8000/auth/signup'), //android emmulator localhost api
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      print(response.body);
      print(response.statusCode);
    } catch (e) {
      return print(e.toString());
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        // Uri.parse('http://127.0.0.1:8000/auth/signup'), //ios emmulator localhost api
        Uri.parse(
            'http://10.0.2.2:8000/auth/login'), //android emmulator localhost api
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      print(response.body);
      print(response.statusCode);
    } catch (e) {
      return print(e.toString());
    }
  }
}
