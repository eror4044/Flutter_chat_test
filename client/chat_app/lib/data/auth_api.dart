import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:3000/"));

  Future<String> login(String username) async {
    final response = await _dio.post('/login', data: {"username": username});
    if (response.statusCode == 200 && response.data['success']) {
      return response.data['token'];
    }
    throw Exception('Failed to login');
  }

  Future<void> register(String username) async {
    final response = await _dio.post('/register', data: {"username": username});
    if (response.statusCode != 200 || !response.data['success']) {
      throw Exception('Failed to register');
    }
  }
}
