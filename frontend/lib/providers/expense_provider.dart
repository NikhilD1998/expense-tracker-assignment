import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/helpers/api_endpoints.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _secureStorage = const FlutterSecureStorage();

class ExpenseState {
  final bool isLoading;
  final String? error;
  final bool success;

  ExpenseState({this.isLoading = false, this.error, this.success = false});

  ExpenseState copyWith({bool? isLoading, String? error, bool? success}) {
    return ExpenseState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success ?? this.success,
    );
  }
}

class ExpenseNotifier extends StateNotifier<ExpenseState> {
  ExpenseNotifier() : super(ExpenseState());

  Future<void> addExpense({
    required String name,
    required double amount,
    required String date,
    required String category,
  }) async {
    state = state.copyWith(isLoading: true, error: null, success: false);
    try {
      final token = await _secureStorage.read(key: 'jwt_token');
      final response = await http.post(
        Uri.parse(ApiEndpoints.addExpense),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'amount': amount,
          'date': date,
          'category': category,
        }),
      );

      if (response.statusCode == 201) {
        state = ExpenseState(isLoading: false, success: true);
      } else {
        final data = jsonDecode(response.body);
        state = ExpenseState(
          isLoading: false,
          error: data['message'] ?? 'Failed to add expense',
        );
      }
    } catch (e) {
      state = ExpenseState(isLoading: false, error: e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAllExpenses() async {
    try {
      final token = await _secureStorage.read(key: 'jwt_token');
      final response = await http.get(
        Uri.parse(ApiEndpoints.getUserExpenses),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['expenses']);
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Failed to fetch expenses');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

final expenseProvider = StateNotifierProvider<ExpenseNotifier, ExpenseState>(
  (ref) => ExpenseNotifier(),
);
