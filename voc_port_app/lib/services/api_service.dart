import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://truck-management-3.onrender.com';

  Future<dynamic> login(
      String mobile,
      String password,
      ) async {

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mobile': mobile,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }
}