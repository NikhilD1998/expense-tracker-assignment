import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/helpers/api_endpoints.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _secureStorage = const FlutterSecureStorage();

class AuthState {
  final UserModel? user;
  final String? token;
  final String? error;

  AuthState({this.user, this.token, this.error});

  AuthState copyWith({UserModel? user, String? token, String? error}) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(data['user']);
        final token = data['token'];
        // Store token securely
        await _secureStorage.write(key: 'jwt_token', value: token);
        state = AuthState(user: user, token: token);
      } else {
        state = AuthState(error: data['message'] ?? 'Login failed');
      }
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'jwt_token');
  }

  void logout() async {
    await _secureStorage.delete(key: 'jwt_token');
    state = AuthState();
  }
}

// Riverpod provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
