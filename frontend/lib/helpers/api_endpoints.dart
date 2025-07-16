class ApiEndpoints {
  static const String baseUrl = "http://192.168.31.235:3000/api";

  static const String login = "$baseUrl/users/login";
  static const String addExpense = "$baseUrl/expenses/add";
  static const String getUserExpenses = "$baseUrl/expenses/all";
}
