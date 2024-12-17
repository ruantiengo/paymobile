import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider {
  final String baseUrl;

  ApiProvider(this.baseUrl);

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final pk = prefs.getString('pk');

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Token': '$token',
        'X-api-key': '$pk',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Erro ao realizar a requisição: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? headers}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final pk = prefs.getString('pk');
    final tenantid = prefs.getString('tenant_id');

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Token': '$token',
        'X-api-key': '$pk',
        'tenantid': '$tenantid',
        ...?headers,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Erro ao realizar a requisição: ${response.statusCode} - ${response.body}');
    }
  }
}
