import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helpers/constants.dart';
import 'package:frontend/helpers/device_dimensions.dart';
import 'package:frontend/helpers/transition_animation.dart';
import 'package:frontend/screens/add_expense_screen.dart';
import 'package:frontend/providers/expense_provider.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DeviceDimensions.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ref.watch(expenseProvider.notifier).getAllExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final expenses = snapshot.data ?? [];
          if (expenses.isEmpty) {
            return const Center(child: Text('No expenses found.'));
          }
          return ListView.builder(
            padding: EdgeInsets.only(bottom: DeviceDimensions.height * 0.12),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return Card(
                color: const Color(0xFFFBFBFB),
                margin: EdgeInsets.symmetric(
                  horizontal: DeviceDimensions.width * 0.04,
                  vertical: DeviceDimensions.height * 0.01,
                ),
                child: ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          expense['name'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: DeviceDimensions.width * 0.045,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '₹${expense['amount']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          fontSize: DeviceDimensions.width * 0.048,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '${expense['category'] ?? ''}\n'
                    '${expense['date'] != null && expense['date'].toString().isNotEmpty ? DateFormat("MMM d, yyyy").format(DateTime.parse(expense['date']).toLocal()) : ''}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: DeviceDimensions.width * 0.035,
                    ),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: DeviceDimensions.width * 0.15,
        height: DeviceDimensions.width * 0.15,
        child: FloatingActionButton(
          onPressed: () {
            navigateWithFade(context, const AddExpenseScreen());
            (context as Element).reassemble();
          },
          backgroundColor: const Color(0xFF29756F),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
